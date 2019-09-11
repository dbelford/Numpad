//
//  KeyboardViewCoordinator.swift
//  NumpadRemap
//
//  Created by David Belford on 6/18/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation
import AppKit

class KeyboardViewCoordinator : Coordinator, WindowCoordinator {

  
  
  var childCoordinators: [Coordinator] = []
  
  var presentingViewController : ViewController
  weak var coordinatorDelegate : KeyboardViewCoordinatorDelegate?
  var mainVC : MainViewController?
  
  var windowController : NSWindowController
//  var contentCoordinator : Coordinator?
  
  init (_ windowController: NSWindowController?) {

    let cvc = ViewController()
    self.windowController = windowController ?? WindowController()
    self.windowController.contentViewController = cvc
    self.presentingViewController = cvc
    self.customize()

  }
  
  init(presentingViewController: ViewController, delegate : KeyboardViewCoordinatorDelegate?) {
    //Initialize main screen ViewController
    //Initialize main screen ViewModel
    
    self.presentingViewController = presentingViewController
    self.coordinatorDelegate = delegate
    self.windowController = WindowController()
    self.windowController.contentViewController = presentingViewController
    self.customize()
  }
  
  func customize() {
    self.windowController.window?.title = "Numpad Launcher"
    self.windowController.window?.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: "Numpad Launcher"))
    self.windowController.window?.isRestorable = true
  }
  
  func presentWindow() {
    self.windowController.showWindow(nil)
    self.present()
  }
  
  func present() {
    
    self.windowController.showWindow(nil)

//    let vm = MainScreenViewModel(delegate: self)
    if mainVC == nil {
      mainVC = MainViewController(preferences: NRPreferences.sharedInstance())
      if let vc = mainVC {
        self.presentingViewController.add(vc)
        self.presentingViewController.view.window?.initialFirstResponder = vc.view
        self.presentingViewController.view.window?.makeFirstResponder(vc.view)
      }
    }
//    vc.bindViewModel(viewModel: vm)

  }
  
  func hide() {
    self.windowController.window?.miniaturize(nil)
  }
  
}

//extension KeyboardViewCoordinator : KeyboardViewCoordinatorDelegate {
//
//  func presentPreferences() {
//    self.coordinatorDelegate?.presentPreferences()
//  }
//
//  func presentScreenShot() {
//    self.coordinatorDelegate?.presentScreenShot()
//  }
//
//}

protocol KeyboardViewCoordinatorDelegate : AnyObject {
  func presentPreferences()
}
