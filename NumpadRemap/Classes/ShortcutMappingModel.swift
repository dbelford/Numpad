//
//  ShortcutMappingModel.swift
//  Numpad
//
//  Created by David Belford on 8/31/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

typealias ANSI_Key_Code = Int

enum BindingStyle {
  case defaultBinding
  case auto
  case dock
  case frequency
  case recency
  case manual
  case other
}

//protocol ShortcutMappingModelUpdates {
//  func
//}

protocol ShortcutMappingModelActions {
  func launchApplication(bundleIdentifier : String)
  func launchApplication(runningApplication : NSRunningApplication)
  func launchApplication(processIdentifier : pid_t)
  func launchApplication(index : Int)
  func launchApplication(keyCode : UInt) -> Bool
}

enum ShortcutMappingModelUpdateProperty {
  case shortcuts
  case hideNumpadNumbers
  case lastProcessIdentifier
  case bindingStyle
  case keyboardType
  case monitor
  case all
}

@objc
class ShortcutMappingModel : NSObject, ShortcutMappingModelActions {
  
  var preferences : NRPreferences!
  var shortcuts : [NRShortcut]            { didSet { self.modelUpdated(.shortcuts) } }
  var hideNumpadNumbers : Bool = true     { didSet { self.modelUpdated(.hideNumpadNumbers) } }
  var lastProcessIdentifier : pid_t?      { didSet { self.modelUpdated(.lastProcessIdentifier) } }
  var bindingStyle : BindingStyle = .defaultBinding { didSet { self.modelUpdated(.bindingStyle) } }
  var keyboardType : KeyboardTypes = .numpad  { didSet { self.modelUpdated(.keyboardType) } }
  var monitor : DABActiveApplicationsMonitor?       { didSet { self.modelUpdated(.monitor) } }
  var observers : [NSKeyValueObservation?] = [] 
  
  private var orderedApps : [NSRunningApplication] = []
  
  override init() {
    self.shortcuts = []
    super.init()
    self.preferences = NRPreferences.sharedInstance()
    self.setup()
    print("Don't use this method, pass preferences to init.")
    // TODO: TODO - Delete method
  }
  
  init(preferences : NRPreferences) {
    // TODO: Implemenation
    self.shortcuts = []
    super.init()
    self.preferences = preferences
    self.setup()
  }
  
  func convertKeyboardType(_ keyboardType : NRKeyboardType) -> KeyboardTypes {
    switch keyboardType {
    case .typeUnknown:
      return .numpad
    case .typeKeypadNumbers:
      return .numbers
    case .typeFullNumpad:
      return .numpad
    case .type10Keyless:
      return .keyboardSm
    case .typeFullKeyboard:
      return .keyboardSm
    }
  }
  
  func setup() {
    
    self.hideNumpadNumbers = self.preferences.hideNumpadNumbers
    self.monitor = DABActiveApplicationsMonitor() // TODO: Move monitor into service, make sure to
    self.monitor?.updateApplicationData()         // move this there too
    self.updateShortcuts()
//    self.bindingStyle = self.bindingFromKeyOrdering(keyOrdering: NRPreferences.sharedInstance().keyOrdering)
    
    self.observers = [
      self.preferences.observe(\NRPreferences.keyboardType, options: NSKeyValueObservingOptions.new) { [weak self] (preferences, changes) in
        if let k = self?.preferences.keyboardType, let keyboardType = self?.convertKeyboardType(k) {
          self?.keyboardType = keyboardType
          self?.updateShortcuts()
        }
      },
      self.preferences.observe(\NRPreferences.keyOrdering, options: NSKeyValueObservingOptions.new) { [weak self] (preferences, changes) in
        guard let strongSelf = self else { return }
//        self?.bindingStyle = strongSelf.bindingFromKeyOrdering(keyOrdering: NRPreferences.sharedInstance().keyOrdering)
        self?.updateShortcuts()
      },
      self.monitor?.observe(\DABActiveApplicationsMonitor.orderedRunningApplications) { [weak self] (monitor, changes) in
        self?.updateShortcuts()
      },
      self.preferences.observe(\NRPreferences.hideNumpadNumbers) { [weak self] (preferences, changes) in
        self?.hideNumpadNumbers = NRPreferences.sharedInstance().hideNumpadNumbers
      }
    ]

  }
  
  func updateShortcuts() {
    let keyboardData = self.keyboardType.data()
    let orderedKeys = keyboardData.keyOrder.joined()
    let shortcutModels = orderedKeys.map { (key) in
      return NRShortcut(keyCode: UInt(key), modifier: .command)
    }
    
    var idx = 1
    if let apps = self.monitor?.orderedRunningApplications, let orderedApps = apps as? [NSRunningApplication] {
      for app in orderedApps {
        if shortcutModels.count > idx {
          let shortcut = shortcutModels[idx]
          shortcut.applicationBundleIdentifier = app.bundleIdentifier
          shortcut.processIdentifier = app.processIdentifier
        }
        idx += 1
      }
    }
    self.shortcuts = shortcutModels
  }
  
  func launchApplication(bundleIdentifier : String) {
    NSWorkspace.shared().launchApplication(withBundleIdentifier: bundleIdentifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
  }
  
  func launchApplication(runningApplication: NSRunningApplication) {
    let frontPid = NSWorkspace.shared().frontmostApplication?.processIdentifier
    let appAlreadyActive = runningApplication.processIdentifier == frontPid
    
    if appAlreadyActive {
      if NRPreferences.sharedInstance().hideOnDeactivate {
        NSApplication.shared().hide(self)
      }
//      runningApplication.activate(options: [])
      self.launchApplication(index: 0)
    } else {
      if let bundleIdentifier = runningApplication.bundleIdentifier {
        self.lastProcessIdentifier = frontPid
//        runningApplication.activate(options: [])
        runningApplication.activate(options: .activateIgnoringOtherApps)
//        NSWorkspace.shared().launchApplication(withBundleIdentifier: bundleIdentifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
      }
    }
    


  }
  
  func launchApplication(processIdentifier: pid_t) {
    if (processIdentifier == -1) { return; }
    let matchedApp = NSWorkspace.shared().runningApplications.filter( { (app) -> Bool in
      return app.processIdentifier == processIdentifier
    }).first
    if let app = matchedApp {
      app.activate(options: [])
//      self.launchApplication(runningApplication: app)
    }

//    //Faster application fronting
//    ProcessSerialNumber pn = {};
    
//    GetProcessForPID(processIdentifier, &pn);
//    SetFrontProcessWithOptions(&pn, kSetFrontProcessFrontWindowOnly);
  }
  
  func launchApplication(keyCode: UInt) -> Bool {
    let matchedShortcut = self.shortcuts.filter { (shortcut) -> Bool in
      return shortcut.keyCode == keyCode
    }
    guard let shortcut = matchedShortcut.first else { return false }
    guard let bundleIdentifier = shortcut.applicationBundleIdentifier else { return false }
    if let pid = shortcut.processIdentifier {
      self.launchApplication(processIdentifier: pid)
    } else {
      self.launchApplication(bundleIdentifier: bundleIdentifier)
    }
//    self.launchApplication(bundleIdentifier: bundleIdentifier)
    return true
  }
  
  func launchApplication(index : Int) {
    if let count = self.monitor?.orderedRunningApplications.count,
      index < count,
      let apps = self.monitor?.orderedRunningApplications as? [NSRunningApplication]   {
      apps[index].activate(options: [])
//      self.launchApplication(runningApplication : apps[index])
    }
  }
//  func launchApplicationForKeycode(keyCode : UInt) -> Bool { }
  
//  func isNumpadNumber(keyCode : UInt) -> Bool { }
//  func isKeyboardNumber(keyCode : UInt) -> Bool { }
//  func numpadANSIKeys(bindingStyle : BindingStyle) -> [ANSI_Key_Code] { }
//  func indexMapping(keyCode : UInt, bindingStyle : BindingStyle) -> Int { }
  
  
  typealias ModelUpdatedCallback = (ShortcutMappingModelUpdateProperty) -> Void
  var modelUpdatedCallbacks = [ModelUpdatedCallback]()
  func onModelUpdated(_ callback : @escaping ModelUpdatedCallback) {
    self.modelUpdatedCallbacks.append(callback)
  }
  
  func modelUpdated(_ property : ShortcutMappingModelUpdateProperty) {
    for callback in modelUpdatedCallbacks {
      callback(property)
    }
  }
}
