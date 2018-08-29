//
//  ApplicationNavigator.swift
//  Numpad
//
//  Created by David Belford on 8/28/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation



class ApplicationNavigator {
  let application: Application
  init(application: Application) {
    self.application = application
  }
  
  func navigateToPreferences() {
    
  }
  
  func navigateToKeypad() {
    
  }
  
  func navigateToKeypadPreferences() {
    
  }
  
}

class KeypadNavigator {
  let parentNavigator: ApplicationNavigator
  let serviceLocator: ServiceLocator
  init(serviceLocator: ServiceLocator, parentNavigator: ApplicationNavigator) {
    self.parentNavigator = parentNavigator
    self.serviceLocator = serviceLocator
  }
  
  func navigateToKeypad() {
    
  }
}

class PreferencesNavigator {
  let parentNavigator: ApplicationNavigator
  let serviceLocator: ServiceLocator
  init(serviceLocator: ServiceLocator, parentNavigator: ApplicationNavigator) {
    self.parentNavigator = parentNavigator
    self.serviceLocator = serviceLocator
  }
  
  func navigateToPreferences() {
  
  }
  
}

class KeypadPreferencesNavigator {
  let parentNavigator: ApplicationNavigator
  let serviceLocator: ServiceLocator
  init(serviceLocator: ServiceLocator, parentNavigator: ApplicationNavigator) {
    self.parentNavigator = parentNavigator
    self.serviceLocator = serviceLocator
  }
  
  func navigateToPreferences() {
    
  }
  
}


