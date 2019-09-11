//
//  NumpadKeyViewModel.swift
//  Numpad
//
//  Created by David Belford on 9/5/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

@objc
class NumpadKeyViewModel : NSObject {
  @objc dynamic let shortcut : NRShortcut!
  let identifier : String! // key.StringValue for ordering keys
  
  @objc dynamic var hideNumpadNumbers : Bool = false
  @objc dynamic var keyName : String {                      get { return self.shortcut.keyCodeString} }
  @objc dynamic var applicationBundleIdentifier : String {  get { return shortcut.applicationBundleIdentifier ?? ""} }
  @objc dynamic var displayName : String {                  get { return self.shortcut.keyCodeString } }
  @objc dynamic var image : NSImage? {
    get {
      guard let pid = self.shortcut.processIdentifier else { return nil }
      return NSRunningApplication(processIdentifier: pid)?.icon
    }
  }
  
  init(shortcut : NRShortcut, identifier : String) {
    self.shortcut = shortcut
    self.identifier = identifier
    super.init()
  }
}
