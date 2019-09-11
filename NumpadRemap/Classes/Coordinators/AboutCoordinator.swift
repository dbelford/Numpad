//
//  AboutCoordinator.swift
//  Numpad
//
//  Created by David Belford on 7/2/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation

class AboutCoordinator : Coordinator, WindowCoordinator {
  
  var childCoordinators: [Coordinator] = []
  var windowController : NSWindowController
  
  init (_ windowController: NSWindowController?) {
    
    self.windowController = WindowController()
    self.windowController.window?.initialFirstResponder = self.windowController.window?.contentView
  }
  
  init(presentingViewController: ViewController, delegate : PreferencesCoordinatorDelegate?) {
    
    self.windowController = WindowController()
    self.windowController.window?.initialFirstResponder = self.windowController.window?.contentView
  }
  
  
  func presentWindow() {
    self.windowController.showWindow(nil)
    self.present()
  }
  
  func present() {
    self.windowController.showWindow(nil)
    self.windowController.window?.makeKey()
  }
  
  func hide() {
    self.windowController.window?.miniaturize(nil)
  }
  
}
