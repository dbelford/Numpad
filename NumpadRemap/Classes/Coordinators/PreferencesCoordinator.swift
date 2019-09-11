//
//  PreferencesCoordinator.swift
//  Numpad
//
//  Created by David Belford on 7/2/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation


class PreferencesCoordinator : Coordinator, WindowCoordinator {

  var childCoordinators: [Coordinator] = []
  
  weak var coordinatorDelegate : PreferencesCoordinatorDelegate?
//  var mainVC : MainViewController?
  
  var windowController : NSWindowController
  var preferencesWindowController : MASPreferencesWindowController
  //  var contentCoordinator : Coordinator?
  
  init (_ windowController: NSWindowController?) {
    let vcs = [NRGeneralPreferencesViewController()!,
               DevicePreferencesViewController(deviceList: DeviceList())!]
    self.preferencesWindowController = NRPreferencesWindowController(viewControllers: vcs, title: "Preferences")
    self.windowController = self.preferencesWindowController
    self.windowController.window?.initialFirstResponder = self.windowController.window?.contentView
  }
  
  init(presentingViewController: ViewController, delegate : PreferencesCoordinatorDelegate?) {
    //Initialize main screen ViewController
    //Initialize main screen ViewModel
    let vcs = [NRGeneralPreferencesViewController()!,
               DevicePreferencesViewController(deviceList: DeviceList())!]
    self.preferencesWindowController = NRPreferencesWindowController(viewControllers: vcs, title: "Preferences")
    self.windowController = self.preferencesWindowController
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

protocol PreferencesCoordinatorDelegate : AnyObject {
//  func presentPreferences()
}
