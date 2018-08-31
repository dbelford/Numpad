//
//  ShortcutMappingModel.swift
//  Numpad
//
//  Created by David Belford on 8/31/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

typealias ANSI_Key_Code = Int

enum BindingStyle {
  case defaultBinding
  case auto
  case dock
  case frequency
  case recency
  case manual
  case other
}

class ShortcutMappingModel {
  var shortcuts : [NRNumpadShortcutModel]
  var bindingStyle : BindingStyle = .defaultBinding
  var hideNumpadNumbers : Bool = true
  var lastProcessIdentifier : Int?
  var monitor : DABActiveApplicationsMonitor?
  
  init(preferences : NRPreferences) {
    // TODO: Implemenation
    shortcuts = []
  }
  
  func launchApplication(app : NSRunningApplication) { }
  func launchApplicationAtIndex(index : Int) { }
//  func launchApplicationForKeycode(keyCode : UInt) -> Bool { }
  
//  func isNumpadNumber(keyCode : UInt) -> Bool { }
//  func isKeyboardNumber(keyCode : UInt) -> Bool { }
//  func numpadANSIKeys(bindingStyle : BindingStyle) -> [ANSI_Key_Code] { }
//  func indexMapping(keyCode : UInt, bindingStyle : BindingStyle) -> Int { }
}
