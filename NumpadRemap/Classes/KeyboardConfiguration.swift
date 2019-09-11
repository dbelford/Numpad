//
//  KeyboardConfiguration.swift
//  NumpadRemap
//
//  Created by David Belford on 10/5/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation


class ActionList : NSObject, Codable {
  var actionone = "TEXT"
}

class KeyboardConfiguration : NSObject, Codable {
  var keyboardID : String = "HELLO"
  var anotherKeyboard : String = "UGH"
  var actions : ActionList = ActionList()
//  
//  override init() {
//    super.init()
//  }
  
  private enum CodingKeys: String, CodingKey {
    case keyboardID
    case anotherKeyboard
    case actions
  }
  
  init(keyboard: String) {
    super.init()
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let keyboardIDData = try container.decodeIfPresent(String.self, forKey: KeyboardConfiguration.CodingKeys.keyboardID)
    let anotherKeyboardData = try container.decodeIfPresent(String.self, forKey: .anotherKeyboard)
    let actionsData = try container.decodeIfPresent(ActionList.self, forKey: KeyboardConfiguration.CodingKeys.actions)
    
    keyboardID = keyboardIDData ?? "New hello"
    anotherKeyboard = anotherKeyboardData ?? "What"
    actions = actionsData ?? ActionList()
    super.init()
  }
}
