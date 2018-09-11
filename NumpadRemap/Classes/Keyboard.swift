//
//  Keyboard.swift
//  Numpad
//
//  Created by David Belford on 8/18/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

// OptionSet not right
//struct  KeyboardStyles : OptionSet {
//  let rawValue: String
//
//  init(rawValue: String) {
//    self.rawValue = rawValue
//  }
//
//  static var
//}

// Struct - Not useable from objc?

//struct KeyboardStyle {
//
//}

// Enum - Not useable from objc

enum KeyboardStyle : String, Codable {
  case Numpad         = "Numpad"
  case Basic          = "Basic Numpad"
  case TenKeyless     = "10 Keyless"
  case FullSize       = "FullSize Keyboard"
  case DeviceSpecific = "Device Specific" // Lookup in a table
  case Unknown        = "Unknown"
}

enum AppBindingStyle : String, Codable {
  case Default        = "Default"     //Probably based on dock?
  case Dock           = "Dock"        //Based on dock
  case Manual         = "Manual"      //Mapped by user or from a json
  case Frequency      = "Frequency"   //Based on observed statistics
  case Recency        = "Recency"     //App Switcher order
}

// Class with String Memebers - Useable from objc

typealias AppName = String
typealias Shortcut = String // TODO: Make NRNumpadShortcutModel

struct Keyboard : Codable {
  var name : String!
  var vendor : Int?
  var product : Int?
  var style : KeyboardStyle = .Numpad
  // More USB Properties
}


class KeyboardMapping: Codable {
  var requireFocus : Bool = true           // Intercept events when not front app
  var alwaysVisible : Bool = false         // Hide after action and when inactive?
  var keepFocusAfterCommand : Bool = false // Could also be a per command setting
}

class AppKeyboardMapping : KeyboardMapping   {
  var bindingStyle : AppBindingStyle = .Default
  var keyActionBindings : [Shortcut] = []
  
//  init(bindingStyle: AppBindingStyle, bindings: [Shortcut]) {
//
//    super.init()
//    self.bindingStyle = bindingStyle
//    self.keyActionBindings = bindings
//  }
  
//  required init(from decoder: Decoder) throws {
//    super.init(from: decoder)
//  }
}

class MenusMapping : KeyboardMapping {
}

class NumpadMapping : KeyboardMapping {
  
}

struct Profile : Codable {
  var keyboard : Keyboard?
  var mapping : [KeyboardMapping]
  var appliesToAllApps : Bool
  var appsAppliedTo : [AppName]?
}

let k = Keyboard(name: "Keyboard", vendor: 0, product: 20, style: KeyboardStyle.Basic)
let m = [MenusMapping(), AppKeyboardMapping(), NumpadMapping()]
let p = Profile(keyboard: k, mapping: m, appliesToAllApps: true, appsAppliedTo: nil)


