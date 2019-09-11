//
//  ViewController.swift
//  NumpadRemap
//
//  Created by David Belford on 6/18/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  override func loadView() {
    self.view = NSView(frame: NSMakeRect(0, 0, 200, 200))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
}

// MARK: Incomplete
//       Lifecyle for add/remove very incomplete
//       - Using NSViewController built in methods will
//         not call didMove/willMove

extension ViewController {
  
  func didMove(toParent: NSViewController?) {
    // Override in subclass a la UIViewController
  }
  
  func willMove(toParent parent: NSViewController?) {
    // Override in subclass a la UIViewController
  }
  
  func add(_ childViewController: NSViewController) {
    
    if let cvc = childViewController as? ViewController {
      cvc.willMove(toParent: self)
    }
    
    addChild(childViewController)
    view.addSubview(childViewController.view)
    
    childViewController.view.mas_makeConstraints { (make) in
      make?.edges.mas_equalTo()(view)?.insets()(NSEdgeInsetsMake(7, 7, 7, 7))
//      make?.edges.equalTo()(view)?.inset(NSEdgeInsetsMake(7, 7, 7, 7))
//      make?.edges.equalTo(view).inset(NSEdgeInsetsMake(7, 7, 7, 7))
    }
//    childViewController.view.snp.makeConstraints { (make) in
//      make.edges.equalTo(view).inset(NSEdgeInsetsMake(7, 7, 7, 7))
//    }
    
    if let cvc = childViewController as? ViewController {
      cvc.didMove(toParent: self)
    }
  }
  
  func remove(_ childViewController: NSViewController) {
    let index = children.firstIndex(of: childViewController)
    if let index = index {
      
      if let cvc = childViewController as? ViewController {
        cvc.willMove(toParent: nil)
      }
      
      removeChild(at: index)
      childViewController.view.removeFromSuperview()
      childViewController.removeFromParent()
      
      if let cvc = childViewController as? ViewController {
        cvc.didMove(toParent: nil)
      }
    }
  }
  
  override func cancelOperation(_ sender: Any?) {
    print("LOGGIT")
  }
}

