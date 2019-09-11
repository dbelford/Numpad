//
//  Application.swift
//  Numpad
//
//  Created by David Belford on 8/28/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

enum ApplicationWindows {
  case Main
  case Preferences
  case Debug
  case About
}

struct WindowCoordinators {
  var main : KeyboardViewCoordinator
  var preferences : PreferencesCoordinator
  var about : AboutCoordinator
  var debug : DebugCoordinator
  
  init(_ primaryWindowController : NSWindowController) {
    self.main = KeyboardViewCoordinator(primaryWindowController)
    self.preferences = PreferencesCoordinator(nil)
    self.about = AboutCoordinator(nil)
    self.debug = DebugCoordinator(nil)
  }
//  lazy var preferences :
//  lazy var debug :
}

class Application: NSObject {
  
//  static let shared = Application()
  
  var windowCoordinators : WindowCoordinators
  
  init(_ primaryWindowController : NSWindowController) {
    self.windowCoordinators = WindowCoordinators(primaryWindowController)
    super.init()
  }
  
  func start() {
    self.windowCoordinators.debug.presentWindow()
    self.windowCoordinators.main.presentWindow()
    
//    let content = MainViewController(preferences: NRPreferences.sharedInstance())
//    if let content = content, let delegate = NSApplication.shared().delegate as? NRAppDelegate {
//      delegate.window?.contentViewController = content
//      delegate.window?.initialFirstResponder = content.childViewControllers.first?.view
//      delegate.window?.makeFirstResponder(content.childViewControllers.first?.view)
//    }
  }
  
  func route(_ route : ApplicationWindows) {
    switch route {
    case .Main:
      self.windowCoordinators.main.present()
    case .Preferences:
      self.windowCoordinators.preferences.present()
    case .About:
      self.windowCoordinators.about.present()
    case .Debug:
      self.windowCoordinators.debug.present()
//      self.windowCoordinators.debug.present()
    }
    
  }
  
}
