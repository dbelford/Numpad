//
//  KeyboardConfigurationsManager.swift
//  NumpadRemap
//
//  Created by David Belford on 10/19/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

extension UserDefaults {
  public enum Keys {
    public static let KeyboardConfigurations = "com.dbelford.keyboardConfigurations.0"
  }
  @objc dynamic var configurations: [KeyboardConfiguration] {
    let d = data(forKey: UserDefaults.Keys.KeyboardConfigurations)
    if let d = d {
      let decoded = try? PropertyListDecoder().decode([KeyboardConfiguration].self, from: d)
      if let decoded = decoded {
        return decoded
      }
    }
    return [KeyboardConfiguration]()
  }
}

class KeyboardConfigurationsManager {
  
  var currentKeyboardConfigurations : [KeyboardConfiguration]
  var preferences : NRPreferences
  var preferencesObservers : [NSKeyValueObservation]?
  
  
  init(preferences : NRPreferences) {
    self.preferences = preferences
//    super.init()
    self.preferencesObservers = []
    self.currentKeyboardConfigurations = []
//      UserDefaults.standard.observe
//      UserDefaults.standard.observe(KeyPath(NRPreferences.), options: <#T##NSKeyValueObservingOptions#>, changeHandler: <#T##(UserDefaults, NSKeyValueObservedChange<Value>) -> Void#>)]
    }
  
  func setConfigurationForDevice(deviceIdentifier: String, configuration: KeyboardConfiguration) {
    
  }
  
}
