//
//  WindowController.swift
//  Numpad
//
//  Created by David Belford on 8/15/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class WindowController : NSWindowController, NSWindowDelegate {
  override func windowDidLoad() {
//    self.window?.titlebarAppearsTransparent = true
    self.window?.styleMask.update(with: .resizable)
    self.window?.standardWindowButton(NSWindowButton.zoomButton)?.isHidden = true
    self.window?.standardWindowButton(NSWindowButton.closeButton)?.isHidden = true
    self.window?.standardWindowButton(NSWindowButton.miniaturizeButton)?.isHidden = true
    
    self.window?.backgroundColor = NSColor.white
    self.window?.isMovableByWindowBackground = true
//    self.window?.nextResponder = self
    self.window?.collectionBehavior = [.moveToActiveSpace, .transient]
    NSApplication.shared().presentationOptions = .disableHideApplication
//    self.window?.initialFirstResponder = self.numpadSettingsController.view
//    self.window?.delegate = self
    if let delegate = (NSApplication.shared().delegate as? NRAppDelegate) {
      delegate.keypadWindow = self.window
      delegate.window = self.window
      self.nextResponder = NSApplication.shared()
    }
    
  }
  
  override func cancelOperation(_ sender: Any?) {
    NSApplication.shared().hide(nil)
  }
  
  
  
//  func windowShouldClose(_ sender: Any) -> Bool {
//    NSApplication.shared().hide(nil)
//    return false
//  }
}
