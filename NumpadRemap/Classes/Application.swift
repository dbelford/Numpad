//
//  Application.swift
//  Numpad
//
//  Created by David Belford on 8/28/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation


class Application: NSObject {
  
  static let shared = Application()
  private override init() {
    super.init()
  }
  
  func start() {
    let content = MainViewController(preferences: NRPreferences.sharedInstance())
    if let content = content, let delegate = NSApplication.shared().delegate as? NRAppDelegate {
      delegate.window?.contentViewController = content
      delegate.window?.initialFirstResponder = content.childViewControllers.first?.view
      delegate.window?.makeFirstResponder(content.childViewControllers.first?.view)
    }
  }
  
}
