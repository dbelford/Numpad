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
  @IBOutlet var window: NSWindow?
//  @IBOutlet var numpadSettingsController : NRNumpadSettingsController!
  @IBOutlet var windowController: NSWindowController!
  
  public lazy var preferencesWindowController : MASPreferencesWindowController = {
    let vcs = [NRGeneralPreferencesViewController()!]
    let wc = NRPreferencesWindowController(viewControllers: vcs, title: "Preferences")
    
    wc.window?.initialFirstResponder = wc.window?.contentView
    return wc
  }()
  
  // MARK: -
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApplication.shared().presentationOptions = .disableHideApplication
    
    let content = MainViewController(preferences: NRPreferences.sharedInstance())
    if let content = content {
      self.window?.contentViewController = content
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
    NSLog("Tried showing")
    self.preferencesWindowController.showWindow(sender)
    self.preferencesWindowController.window?.makeKey()
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


