//
//  NumpadKeyViewModel.swift
//  Numpad
//
//  Created by David Belford on 9/5/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class NumpadKeyViewModel : NSObject {
  let shortcut : NRShortcut!
  let identifier : String! // key.StringValue for ordering keys
  
  var hideNumpadNumbers : Bool = false
  var keyName : String {                      get { return self.shortcut.keyCodeString} }
  var applicationBundleIdentifier : String {  get { return shortcut.applicationBundleIdentifier ?? ""} }
  var displayName : String {                  get { return self.shortcut.keyCodeString } }
  var image : NSImage? {
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
