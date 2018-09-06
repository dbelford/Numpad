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

protocol ShortcutMappingModelActions {
  func launchApplication(bundleIdentifier : String)
  func launchApplication(runningApplication : NSRunningApplication)
  func launchApplication(processIdentifier : pid_t)
  func launchApplication(index : Int)
  func launchApplication(keyCode : UInt) -> Bool
}

class ShortcutMappingModel : NSObject, ShortcutMappingModelActions {

  
  var shortcuts : [NRShortcut]
  var bindingStyle : BindingStyle = .defaultBinding
  var hideNumpadNumbers : Bool = true
  var lastProcessIdentifier : pid_t?
  var monitor : DABActiveApplicationsMonitor?
  var observers : [NSKeyValueObservation] = []
  
  private var orderedApps : [NSRunningApplication] = []
  
  
  init(preferences : NRPreferences) {
    // TODO: Implemenation
    shortcuts = []
    
  }
  
  func bindingFromKeyOrdering(keyOrdering : NRNumpadKeyOrdering) -> BindingStyle {
    return .defaultBinding
  }
  
  func setup() {
    self.monitor = DABActiveApplicationsMonitor()
    self.hideNumpadNumbers = NRPreferences.sharedInstance().hideNumpadNumbers
    self.bindingStyle = self.bindingFromKeyOrdering(keyOrdering: NRPreferences.sharedInstance().keyOrdering)
    
    observers.append(NRPreferences.sharedInstance().observe(\NRPreferences.keyOrdering, options: NSKeyValueObservingOptions.new) { (preferences, changes) in
      self.bindingStyle = self.bindingFromKeyOrdering(keyOrdering: NRPreferences.sharedInstance().keyOrdering)
    })
    observers.append(self.observe(\ShortcutMappingModel.monitor?.orderedRunningApplications) { [weak self] (monitor, changes) in
      self?.updateShortcuts()
    })
    observers.append(self.observe(\ShortcutMappingModel.bindingStyle) { [weak self] (monitor, changes) in
      self?.updateShortcuts()
    })
    observers.append(NRPreferences.sharedInstance().observe(\NRPreferences.hideNumpadNumbers) { (preferences, changes) in
      self.hideNumpadNumbers = NRPreferences.sharedInstance().hideNumpadNumbers
    })
  }
  
  func updateShortcuts() {
    let orderedKeys = Keyboards.numpad.data().keyOrder.joined()
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
      self.launchApplication(index: 0)
    } else {
      if let bundleIdentifier = runningApplication.bundleIdentifier {
        self.lastProcessIdentifier = frontPid
        NSWorkspace.shared().launchApplication(withBundleIdentifier: bundleIdentifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
      }
    }

  }
  
  func launchApplication(processIdentifier: pid_t) {
    if (processIdentifier == -1) { return; }
    let matchedApp = NSWorkspace.shared().runningApplications.filter( { (app) -> Bool in
      return app.processIdentifier == processIdentifier
    }).first
    if let app = matchedApp {
      self.launchApplication(runningApplication: app)
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
    self.launchApplication(bundleIdentifier: bundleIdentifier)
    return true
  }
  
  func launchApplication(index : Int) {
    if let count = self.monitor?.orderedRunningApplications.count,
      index < count,
      let apps = self.monitor?.orderedRunningApplications as? [NSRunningApplication]   {
      self.launchApplication(runningApplication : apps[index])
    }
  }
//  func launchApplicationForKeycode(keyCode : UInt) -> Bool { }
  
//  func isNumpadNumber(keyCode : UInt) -> Bool { }
//  func isKeyboardNumber(keyCode : UInt) -> Bool { }
//  func numpadANSIKeys(bindingStyle : BindingStyle) -> [ANSI_Key_Code] { }
//  func indexMapping(keyCode : UInt, bindingStyle : BindingStyle) -> Int { }
}
