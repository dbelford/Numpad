//
//  KeyboardConstants.swift
//  Numpad
//
//  Created by David Belford on 8/29/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

struct KeyOrders {
  static let Numpad = [
    [kVK_ANSI_KeypadClear, kVK_ANSI_KeypadDivide, kVK_ANSI_KeypadMultiply, kVK_ANSI_KeypadMinus],
    [kVK_ANSI_Keypad7, kVK_ANSI_Keypad8, kVK_ANSI_Keypad9, kVK_ANSI_KeypadPlus],
    [kVK_ANSI_Keypad4, kVK_ANSI_Keypad5, kVK_ANSI_Keypad6, kVK_ANSI_KeypadClear],
    [kVK_ANSI_Keypad1, kVK_ANSI_Keypad2, kVK_ANSI_Keypad3, kVK_ANSI_KeypadEnter],
    [kVK_ANSI_Keypad0, kVK_ANSI_KeypadDecimal]
  ]
  static let Numbers = [
    [kVK_ANSI_Keypad7, kVK_ANSI_Keypad8, kVK_ANSI_Keypad9],
    [kVK_ANSI_Keypad4, kVK_ANSI_Keypad5, kVK_ANSI_Keypad6],
    [kVK_ANSI_Keypad1, kVK_ANSI_Keypad2, kVK_ANSI_Keypad3],
    [kVK_ANSI_Keypad0]
  ]
  static let KeyboardSm = [
    [kVK_ANSI_Grave, kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3, kVK_ANSI_4, kVK_ANSI_5, kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9, kVK_ANSI_0, kVK_ANSI_Minus, kVK_ANSI_Equal, kVK_Delete],
    [kVK_Tab, kVK_ANSI_Q, kVK_ANSI_W, kVK_ANSI_E, kVK_ANSI_R, kVK_ANSI_T, kVK_ANSI_Y, kVK_ANSI_U, kVK_ANSI_I, kVK_ANSI_O, kVK_ANSI_P, kVK_ANSI_LeftBracket, kVK_ANSI_RightBracket, kVK_ANSI_Backslash],
    [kVK_CapsLock, kVK_ANSI_A, kVK_ANSI_S, kVK_ANSI_D, kVK_ANSI_F, kVK_ANSI_G, kVK_ANSI_H, kVK_ANSI_J, kVK_ANSI_K, kVK_ANSI_L, kVK_ANSI_Semicolon, kVK_ANSI_Quote, kVK_Return],
    [kVK_Shift, kVK_ANSI_Z, kVK_ANSI_X, kVK_ANSI_C, kVK_ANSI_V, kVK_ANSI_B, kVK_ANSI_N, kVK_ANSI_M, kVK_ANSI_Comma, kVK_ANSI_Period, kVK_ANSI_Slash, kVK_RightShift],
    [kVK_Function, kVK_Control, kVK_Option, kVK_Command, kVK_Space, kVK_RightCommand, kVK_RightOption, kVK_LeftArrow, kVK_UpArrow, kVK_DownArrow, kVK_RightArrow]
  ]
  static let KeyboardMd = [
    [kVK_ANSI_Grave, kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3, kVK_ANSI_4, kVK_ANSI_5, kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9, kVK_ANSI_Minus, kVK_ANSI_Equal, kVK_Delete],
    [kVK_Tab, kVK_ANSI_Q, kVK_ANSI_W, kVK_ANSI_E, kVK_ANSI_R, kVK_ANSI_T, kVK_ANSI_Y, kVK_ANSI_U, kVK_ANSI_I, kVK_ANSI_O, kVK_ANSI_P, kVK_ANSI_LeftBracket, kVK_ANSI_RightBracket, kVK_ANSI_Backslash],
    [kVK_CapsLock, kVK_ANSI_A, kVK_ANSI_S, kVK_ANSI_D, kVK_ANSI_F, kVK_ANSI_G, kVK_ANSI_H, kVK_ANSI_J, kVK_ANSI_K, kVK_ANSI_L, kVK_ANSI_Semicolon, kVK_ANSI_Quote, kVK_Return],
    [kVK_Shift, kVK_ANSI_Z, kVK_ANSI_X, kVK_ANSI_C, kVK_ANSI_V, kVK_ANSI_B, kVK_ANSI_N, kVK_ANSI_M, kVK_ANSI_Comma, kVK_ANSI_Period, kVK_ANSI_Slash, kVK_RightShift],
    [kVK_Function, kVK_Control, kVK_Option, kVK_Command, kVK_Space, kVK_RightCommand, kVK_RightOption, kVK_LeftArrow, kVK_UpArrow, kVK_DownArrow, kVK_RightArrow]
  ]
  static let KeyboardLg = [
    [kVK_ANSI_Grave, kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3, kVK_ANSI_4, kVK_ANSI_5, kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9, kVK_ANSI_Minus, kVK_ANSI_Equal, kVK_Delete],
    [kVK_Tab, kVK_ANSI_Q, kVK_ANSI_W, kVK_ANSI_E, kVK_ANSI_R, kVK_ANSI_T, kVK_ANSI_Y, kVK_ANSI_U, kVK_ANSI_I, kVK_ANSI_O, kVK_ANSI_P, kVK_ANSI_LeftBracket, kVK_ANSI_RightBracket, kVK_ANSI_Backslash],
    [kVK_CapsLock, kVK_ANSI_A, kVK_ANSI_S, kVK_ANSI_D, kVK_ANSI_F, kVK_ANSI_G, kVK_ANSI_H, kVK_ANSI_J, kVK_ANSI_K, kVK_ANSI_L, kVK_ANSI_Semicolon, kVK_ANSI_Quote, kVK_Return],
    [kVK_Shift, kVK_ANSI_Z, kVK_ANSI_X, kVK_ANSI_C, kVK_ANSI_V, kVK_ANSI_B, kVK_ANSI_N, kVK_ANSI_M, kVK_ANSI_Comma, kVK_ANSI_Period, kVK_ANSI_Slash, kVK_RightShift],
    [kVK_Function, kVK_Control, kVK_Option, kVK_Command, kVK_Space, kVK_RightCommand, kVK_RightOption, kVK_LeftArrow, kVK_UpArrow, kVK_DownArrow, kVK_RightArrow]
  ]
}

struct KeyAttributes {
  var width : CGFloat = 1
  var height : CGFloat = 1
  var assignable : Bool = true
  var visible : Bool = true
  var emptyTrailing: Bool = false
  var flexibleWidth : Bool = false
  
  init(width: CGFloat, height : CGFloat) {
    self.width = width
    self.height = height
  }
  
  init(assignable: Bool, visible : Bool) {
    self.assignable = assignable
    self.visible = visible
  }
  
  init(doesNotHaveTrailing: Bool) {
    self.emptyTrailing = doesNotHaveTrailing
  }
  
  init(width: CGFloat, height : CGFloat, assignable: Bool, visible : Bool, doesNotHaveTrailing: Bool, flexibleWidth: Bool) {
    self.width = width
    self.height = height
    self.assignable = assignable
    self.visible = visible
    self.emptyTrailing = doesNotHaveTrailing
    self.flexibleWidth = flexibleWidth
  }
}



struct KeyboardProperties {
  struct Widths {
    static let Numpad = CGFloat(KeyOrders.Numpad[0].count)
    static let Numbers = CGFloat(KeyOrders.Numbers[0].count)
    static let KeyboardSm = CGFloat(14.6)
    static let KeyboardMd = CGFloat(14.6)
    static let KeyboardLg = CGFloat(14.6)
  }
  
  static let Numpad = [
    kVK_ANSI_KeypadClear : KeyAttributes.init(assignable: false, visible: false),
    kVK_ANSI_Keypad0 : KeyAttributes(width: 2, height: 1),
    kVK_ANSI_KeypadEnter : KeyAttributes(width: 1, height: 2),
    kVK_ANSI_KeypadDecimal : KeyAttributes(doesNotHaveTrailing: true)
  ]
  
  static let Numbers = [
    kVK_ANSI_Keypad0 : KeyAttributes(width: 2, height: 1, assignable: true, visible: true, doesNotHaveTrailing: true, flexibleWidth: false)
  ]
  
  static let KeyboardSm = [
    kVK_Delete : KeyAttributes(width: 1.6, height: 1),
    kVK_Tab : KeyAttributes(width: 1.6, height: 1),
    kVK_CapsLock : KeyAttributes(width: 1.8, height: 1),
    kVK_Return : KeyAttributes(width: 1.8, height: 1),
    kVK_Shift : KeyAttributes(width: 2.3, height: 1),
    kVK_RightShift : KeyAttributes(width: 2.3, height: 1),
    kVK_Command : KeyAttributes(width: 1.3, height: 1),
    kVK_Space : KeyAttributes(width: 5.0, height: 1, assignable: true, visible: true, doesNotHaveTrailing: false, flexibleWidth: true),
    kVK_RightCommand : KeyAttributes(width: 1.3, height: 1),
    kVK_UpArrow : KeyAttributes(width:0.5, height: 1),
    kVK_DownArrow : KeyAttributes(width:0.5, height: 1)
  ]
  
  static let KeyboardMd = [
    kVK_Delete : KeyAttributes(width: 1.6, height: 1),
    kVK_Tab : KeyAttributes(width: 1.6, height: 1),
    kVK_CapsLock : KeyAttributes(width: 1.8, height: 1),
    kVK_Return : KeyAttributes(width: 1.8, height: 1),
    kVK_Shift : KeyAttributes(width: 2.3, height: 1),
    kVK_RightShift : KeyAttributes(width: 2.3, height: 1),
    kVK_Command : KeyAttributes(width: 1.3, height: 1),
    kVK_Space : KeyAttributes(width: 5.0, height: 1, assignable: true, visible: true, doesNotHaveTrailing: false, flexibleWidth: true),
    kVK_RightCommand : KeyAttributes(width: 1.3, height: 1),
    kVK_UpArrow : KeyAttributes(width:0.5, height: 1),
    kVK_DownArrow : KeyAttributes(width:0.5, height: 1)
  ]
  
  static let KeyboardLg = [
    kVK_Delete : KeyAttributes(width: 1.6, height: 1),
    kVK_Tab : KeyAttributes(width: 1.6, height: 1),
    kVK_CapsLock : KeyAttributes(width: 1.8, height: 1),
    kVK_Return : KeyAttributes(width: 1.8, height: 1),
    kVK_Shift : KeyAttributes(width: 2.3, height: 1),
    kVK_RightShift : KeyAttributes(width: 2.3, height: 1),
    kVK_Command : KeyAttributes(width: 1.3, height: 1),
    kVK_Space : KeyAttributes(width: 5.0, height: 1, assignable: true, visible: true, doesNotHaveTrailing: false, flexibleWidth: true),
    kVK_RightCommand : KeyAttributes(width: 1.3, height: 1),
    kVK_UpArrow : KeyAttributes(width:0.5, height: 1),
    kVK_DownArrow : KeyAttributes(width:0.5, height: 1)
  ]
}

protocol KeyboardDetailsType {
  var keyboardProperties : [Int : KeyAttributes] { get }
  var keyboardWidth : CGFloat { get }
  var keyOrder : [[Int]]{ get }
}

struct NumpadKeyboardDetails : KeyboardDetailsType {
  var keyboardProperties = KeyboardProperties.Numpad
  var keyboardWidth = KeyboardProperties.Widths.Numpad
  var keyOrder = KeyOrders.Numpad
}

struct NumbersKeyboardDetails : KeyboardDetailsType {
  var keyboardProperties = KeyboardProperties.Numbers
  var keyboardWidth = KeyboardProperties.Widths.Numbers
  var keyOrder = KeyOrders.Numbers
}

struct KeyboardSmKeyboardDetails : KeyboardDetailsType {
  var keyboardProperties = KeyboardProperties.KeyboardSm
  var keyboardWidth = KeyboardProperties.Widths.KeyboardSm
  var keyOrder = KeyOrders.KeyboardSm
}

struct KeyboardMdKeyboardDetails : KeyboardDetailsType {
  var keyboardProperties = KeyboardProperties.KeyboardMd
  var keyboardWidth = KeyboardProperties.Widths.KeyboardMd
  var keyOrder = KeyOrders.KeyboardMd
}

struct KeyboardLgKeyboardDetails : KeyboardDetailsType {
  var keyboardProperties = KeyboardProperties.KeyboardLg
  var keyboardWidth = KeyboardProperties.Widths.KeyboardLg
  var keyOrder = KeyOrders.KeyboardLg
}

enum KeyboardTypes : String, RawRepresentable {
  
  case numpad = "Numpad"//(NumpadKeyboardDetails)
  case numbers = "Numbers" //(NumbersKeyboardDetails)
  case keyboardSm = "Small Keyboard"//(KeyboardSmKeyboardDetails)
  case keyboardMd = "Medium Keyboard"//(KeyboardMdKeyboardDetails)
  case keyboardLg = "Large Keyboard" //(KeyboardLgKeyboardDetails)
  
  func data() -> KeyboardDetailsType {
    switch self {
    case .numbers:
      return NumbersKeyboardDetails()
    case .numpad:
      return NumpadKeyboardDetails()
    case .keyboardSm:
      return KeyboardSmKeyboardDetails()
    case .keyboardMd:
      return KeyboardMdKeyboardDetails()
    case .keyboardLg:
      return KeyboardLgKeyboardDetails()
    }
  }
  
  init(_ keyboardType : NRKeyboardType) {
    switch keyboardType {
    case .typeUnknown:
      self = .numpad
    case .typeKeypadNumbers:
      self = .numbers
    case .typeFullNumpad:
      self = .numpad
    case .typeCompact:
      self = .keyboardSm
    case .type10Keyless:
      self = .keyboardMd
    case .typeFullKeyboard:
      self = .keyboardLg
    }
  }
  
  func nrKeyboardType() -> NRKeyboardType {
    return KeyboardTypes.toNRKeyboardType(self)
  }
  
  static func toNRKeyboardType(_ type: KeyboardTypes) -> NRKeyboardType {
    switch type {
    case .numbers:
      return .typeKeypadNumbers
    case .numpad:
      return .typeFullNumpad
    case .keyboardSm:
      return .typeCompact
    case .keyboardMd:
      return .type10Keyless
    case .keyboardLg:
      return .typeFullKeyboard
    }
  }
  
  
  // Type safe allValues till swift ~4.2 available
  // From: https://stackoverflow.com/a/46853256
  static var allValues: [KeyboardTypes] = {
    var allValues: [KeyboardTypes] = []
    switch (KeyboardTypes.numbers) {
    case .numbers: allValues.append(.numbers); fallthrough
    case .numpad: allValues.append(.numpad); fallthrough
    case .keyboardSm: allValues.append(.keyboardSm); fallthrough
    case .keyboardMd: allValues.append(.keyboardMd); fallthrough
    case .keyboardLg: allValues.append(.keyboardLg);
    }
    return allValues
  }()
  
  static var allRawValues: [String] = {
    return KeyboardTypes.allValues.map({ (type) -> String in
      return type.rawValue
    })
  }()
}
