//
//  DebugCoordinator.swift
//  Numpad
//
//  Created by David Belford on 7/2/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation


class DebugCoordinator : Coordinator, WindowCoordinator {
  
  var childCoordinators: [Coordinator] = []
  var windowController : NSWindowController
  
  init (_ windowController: NSWindowController?) {
    
//    self.windowController = WindowController()
    self.windowController = NSStoryboard(name: NSStoryboard.Name(rawValue: "DebugStoryboard"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DebugWindowController")) as! NSWindowController
    self.windowController.window?.initialFirstResponder = self.windowController.window?.contentView
    NSLog("\(String(describing: self.windowController.contentViewController)), \(String(describing: self.windowController.contentViewController?.view))")
//    (name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as UIViewController
    // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
    
//    self.presentViewController(viewController, animated: false, completion: nil)
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

