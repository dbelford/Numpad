//
//  NSResponder+Log.swift
//  Numpad
//
//  Created by David Belford on 8/15/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

extension NSResponder {
  func logResponders() {
    NSLog("Me: \(self) Next Responder: \(self.nextResponder)")
    if let nxt = self.nextResponder  {
      nxt.logResponders()
    }
  }
}
