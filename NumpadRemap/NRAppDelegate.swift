//
//  NRAppDelegate.swift
//  Numpad
//
//  Created by David Belford on 8/9/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation
import Cocoa

@objc class NRAppDelegate : NSResponder, NSApplicationDelegate, NSWindowDelegate {
  var keypadWindow: NSWindow?
  var app : Application?
  @IBOutlet var window: NSWindow?
//  @IBOutlet var numpadSettingsController : NRNumpadSettingsController!
  @IBOutlet var windowController: NSWindowController!
  
  public lazy var preferencesWindowController : MASPreferencesWindowController = {
    let vcs = [NRGeneralPreferencesViewController()!,
               DevicePreferencesViewController(deviceList: DeviceList())!]
    let wc = NRPreferencesWindowController(viewControllers: vcs, title: "Preferences")
    
    wc.window?.initialFirstResponder = wc.window?.contentView
    return wc
  }()
  
  // MARK: -
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApplication.shared().presentationOptions = .disableHideApplication

    
//    NSApplication.shared().mainWindow = self.window
//    self.window?.makeKeyAndOrderFront(self)
    if let wc = self.window?.windowController {
      self.app = Application(wc)
      //    self.app = Application(WindowController())
      app?.start()
    }
    
//    self.window.initialFirstResponder = self.numpadSettingsController.view
//    self.window.delegate = self
//
//    NRPreferences.sharedInstance().rac_values(forKeyPath: #keyPath(NRPreferences.keyHeight), observer: self).subscribeNext { [weak self] heightClassO in
//      guard let strongSelf = self else { return }
//      guard let heightClassInt = heightClassO as? Int else { return }
//      guard let heightClass = NRNumpadKeyHeight(rawValue: heightClassInt) else { return }
//      switch (heightClass) {
//      case .small:
//        strongSelf.window.setContentSize(NSSize(width: 320, height: 320))
//      case .medium:
//        strongSelf.window.setContentSize(NSSize(width: 480, height: 480))
//      case .large:
//        strongSelf.window.setContentSize(NSSize(width: 640, height: 640))
//      }
//      if let center = (NRPreferences.sharedInstance()?.centerNumpad), center {
//        strongSelf.window.center(in: strongSelf.window.screen)
//      }
//    }
    
//    UserDefaults.resetStandardUserDefaults()
//    MASShortcutBinder.shared().bindShortcut(withDefaultsKey: kAppActivationShortcutKey) { [weak self] in
//      guard let strongSelf = self else { return }
//      strongSelf.numpadSettingsController.numpadModel.launch(NSRunningApplication.current())
//    }
  }
  
  func windowShouldClose(_ sender: Any) -> Bool {
    NSApplication.shared().hide(nil)
    return false
  }
  
  
  
  
  func applicationWillBecomeActive(_ notification: Notification) {
    if let sharedPref = NRPreferences.sharedInstance(), (sharedPref.centerNumpad) {
      self.window?.center(in: NSScreen.mouse())
      self.keypadWindow?.center(in: NSScreen.mouse())
    }
    
    self.window?.makeKeyAndOrderFront(self)
    self.keypadWindow?.makeKeyAndOrderFront(self)
  }

  func applicationWillResignActive(_ notification: Notification) {
    if ( NRPreferences.sharedInstance().hideOnDeactivate ) {
      NSApplication.shared().hide(self)
    }
  }

  // MARK: - Preferences
  
  @IBAction func showPreferencesWindow(_ sender: Any?) {
    self.app?.route(ApplicationWindows.Preferences)
//    NSLog("Tried showing")
//    self.preferencesWindowController.showWindow(sender)
//    self.preferencesWindowController.window?.makeKey()
  }
  
  @IBAction func pause(_ sender: Any?) {
//    the pause button works now.
//    the storyboard wasn't working because ViewController broke loading, NSViewController for DebugViewController super class worked
//    need to figure out if there's a way to fix, or if other things should be in storyboard.
//    and what useful things to add to debugviewcontroller
    //    NSLog("Tried showing")
    //    self.preferencesWindowController.showWindow(sender)
    //    self.preferencesWindowController.window?.makeKey()
  }

  //   MARK: - Etc.
  
  override var acceptsFirstResponder: Bool { return true }
  
  override func keyDown(with event: NSEvent) {
    super.keyDown(with: event)
  }
  @IBAction func printLayout(sender: Any?) {
    NSLog("%@", [self.window?.contentView?.perform(Selector(("_subtreeDescription")))])
  }
  
  @IBAction func printConstraints(sender: Any?) {
    self.window?.visualizeConstraints([])
    
  }
  
}


