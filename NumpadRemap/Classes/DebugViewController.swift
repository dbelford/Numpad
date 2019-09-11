//
//  DebugViewController.swift
//  Numpad
//
//  Created by David Belford on 7/2/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation

class DebugViewController : NSViewController {
  
  @IBOutlet var pauseButton : NSButton!
  
  
  override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
//    self.windowController = NSStoryboard(name: "DebugStoryboard", bundle: nil).instantiateController(withIdentifier: "DebugWindowController") as! NSWindowController
//    DebugViewController
  }
  
//  loadview
  
  @IBAction func pauseClicked(_ sender: Any?) {
    
    NSApplication.shared().sendAction(#selector(NRAppDelegate.pause(_:)), to: nil, from: sender)
    
  }
  
}
