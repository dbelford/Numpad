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
    self.window?.styleMask.update(with: NSWindow.StyleMask.resizable)
    self.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
    self.window?.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
    self.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
    
    self.window?.backgroundColor = NSColor.white
    self.window?.isMovableByWindowBackground = true
    self.window?.collectionBehavior = [NSWindow.CollectionBehavior.moveToActiveSpace, NSWindow.CollectionBehavior.transient]
    NSApplication.shared.presentationOptions = NSApplication.PresentationOptions.disableHideApplication

    if let delegate = (NSApplication.shared.delegate as? NRAppDelegate) {
      delegate.keypadWindow = self.window
      delegate.window = self.window
      self.nextResponder = NSApplication.shared
    }
  }
  
  override func cancelOperation(_ sender: Any?) {
    NSApplication.shared.hide(nil)
  }
  
}
