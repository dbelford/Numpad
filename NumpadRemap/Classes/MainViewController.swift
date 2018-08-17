//
//  MainViewController.swift
//  Numpad
//
//  Created by David Belford on 8/14/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class MainViewController : NSViewController {
  @IBOutlet var actionMenu : NSMenu!
  @IBAction func tryTodos(_ sender: NSMenuItem) {
    NSWorkspace.shared().openFile("/Users/dbelford/Projects/osx.launchpad-remap/TODO.txt", withApplication: "Sublime Text 3.app")
  }
  @IBAction func tryQuit(_ sender: NSMenuItem) {
    NSRunningApplication.current().terminate()
  }
  @IBAction func tryAbout(_ sender: NSMenuItem) {}
  @IBAction func tryPreferences(_ sender: NSMenuItem) {
    self.doCommand(by: #selector(NRAppDelegate.showPreferencesWindow))
  }
  @IBAction func showMenu(_ sender : NSButton) {
    if let menu = sender.menu, let event = NSApplication.shared().currentEvent {
      NSMenu.popUpContextMenu(menu, with: event, for: sender)
    }
    
  }
}
