//
//  Shortcut.swift
//  Numpad
//
//  Created by David Belford on 8/31/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class NRShortcut : MASShortcut {
  var keyName : String?
  var displayName : String?
  var applicationBundleIdentifier : String?
  var image : NSImage?
  var processIdentifier : pid_t?
  
  enum CodingKeys: String, CodingKey {
    case keyName
    case displayName
    case applicationBundleIdentifier
    case image
    case processIdentifier
  }
  
  public init(keyCode : UInt, modifier: NSEvent.ModifierFlags) {
    super.init(keyCode: keyCode, modifierFlags: modifier.rawValue)
  }
  
  override func encode(with aCoder: NSCoder) {
    aCoder.encode(keyName, forKey: CodingKeys.keyName.rawValue)
    aCoder.encode(displayName, forKey: CodingKeys.displayName.rawValue)
    aCoder.encode(applicationBundleIdentifier, forKey: CodingKeys.applicationBundleIdentifier.rawValue)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.keyName = aDecoder.decodeObject(forKey: CodingKeys.keyName.rawValue) as? String
    self.displayName = aDecoder.decodeObject(forKey: CodingKeys.displayName.rawValue) as? String
    self.applicationBundleIdentifier = aDecoder.decodeObject(forKey: CodingKeys.applicationBundleIdentifier.rawValue) as? String
//    let values = try aDecoder.container(keyedBy: CodingKeys.self)
//    data = try values.dec
  }
}
