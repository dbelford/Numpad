//
//  ExpandedNumpadView.swift
//  Numpad
//
//  Created by David Belford on 8/15/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class ExpandedNumpadView : BTRView {
  @IBOutlet var viewModel : NRNumpadViewModel? {
    didSet {
      NSLog("Did set \(viewModel)")
      vmObserver = viewModel?.observe(\NRNumpadViewModel.numpadKeys, options: [.new]) { [weak self] (view, change) in
        NSLog("The change: \(view) \(change)")
        guard let strongSelf = self else { return }
        strongSelf.updateKeys()
      }
    }
    
  }
  var keyViews : [NRNumpadKeyView]?
  var keyViewsSignal : RACSignal!
  var vmObserver : NSKeyValueObservation!
  override var acceptsFirstResponder: Bool {
    get {
      return true
    }
  }
  
  lazy var keyOrder : [[Int]] = {
    return [
      [kVK_ANSI_KeypadClear, kVK_ANSI_KeypadDivide, kVK_ANSI_KeypadMultiply, kVK_ANSI_KeypadMinus],
      [kVK_ANSI_Keypad7, kVK_ANSI_Keypad8, kVK_ANSI_Keypad9, kVK_ANSI_KeypadPlus],
      [kVK_ANSI_Keypad4, kVK_ANSI_Keypad5, kVK_ANSI_Keypad6, kVK_ANSI_KeypadClear],
      [kVK_ANSI_Keypad1, kVK_ANSI_Keypad2, kVK_ANSI_Keypad3, kVK_ANSI_KeypadEnter],
      [kVK_ANSI_Keypad0, kVK_ANSI_KeypadDecimal]
    ]
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect, layerHosted: true)
//    self.keyViewsSignal = self.rac_values(forKeyPath: #keyPath(ExpandedNumpadView.viewModel.numpadKeys), observer: self).map({ [weak self] kvms -> [NSView]? in
//      guard let strongSelf = self else { return nil }
//      guard let keyViewModels = kvms as? [NRNumpadKeyViewModel] else { return nil }
//      let views = keyViewModels.map { (vm : NRNumpadKeyViewModel) -> NSView in
//        let view = NRNumpadKeyView.init(frame: NSMakeRect(0, 0, 400, 400))
//        view.iconImageView.image = vm.image
//        view.keyLabel.stringValue = vm.keyName
//        view.identifier = String.init(vm.shortcut.keyCode)
//        view.addTarget(strongSelf, action: #selector(ExpandedNumpadView.pressedAppButton), for: BTRControlEvents.mouseUpInside)
//
//        _ = RACObserve(target: NRPreferences.sharedInstance(), #keyPath(NRPreferences.hideNumpadNumbers)) ~> RAC(view.keyLabel, #keyPath(BTRLabel.isHidden))
//
//        return view
//      }
//
//
//      strongSelf.subviews.forEach({ (view) in view.removeFromSuperview() })
//      views.forEach({ (view) in strongSelf.addSubview(view) })
//      strongSelf.needsUpdateConstraints = true
//
//      return views
//    })
    

    
    if case self = self {
      vmObserver = self.observe(\ExpandedNumpadView.viewModel?) { (view, change) in
        NSLog("The change: \(change.newValue)")
      }
    }
    self.wantsLayer = true
    
  }
  
  func updateKeys() {
    let views : [NRNumpadKeyView] = []
    guard let keyViewModels = self.viewModel?.numpadKeys else { return }
    for (rowIndex, row) in self.keyOrder.enumerated() {
      for (keyIndex, key) in row.enumerated() {
        let view = NRNumpadKeyView.init(frame: NSMakeRect(0, 0, 400, 400))
        let vm = keyViewModels.first(where: { (keyViewModel) -> Bool in
          return keyViewModel.shortcut.keyCode == keyIndex
        })
        view.iconImageView.image = vm?.image
        view.keyLabel.stringValue = vm?.keyName ?? ""
        view.identifier = String.init(vm?.shortcut.keyCode)
        view.addTarget(self, action: #selector(ExpandedNumpadView.pressedAppButton), for: BTRControlEvents.mouseUpInside)
        
        _ = RACObserve(target: NRPreferences.sharedInstance(), #keyPath(NRPreferences.hideNumpadNumbers)) ~> RAC(view.keyLabel, #keyPath(BTRLabel.isHidden))
      }
    }
    let views = keyViewModels.map { (vm : NRNumpadKeyViewModel) -> NRNumpadKeyView in
      let view = NRNumpadKeyView.init(frame: NSMakeRect(0, 0, 400, 400))
      view.iconImageView.image = vm.image
      view.keyLabel.stringValue = vm.keyName
      view.identifier = String.init(vm.shortcut.keyCode)
      view.addTarget(self, action: #selector(ExpandedNumpadView.pressedAppButton), for: BTRControlEvents.mouseUpInside)
      
      _ = RACObserve(target: NRPreferences.sharedInstance(), #keyPath(NRPreferences.hideNumpadNumbers)) ~> RAC(view.keyLabel, #keyPath(BTRLabel.isHidden))
      
      return view
    }
    
    self.keyViews = views
    self.subviews.forEach({ (view) in view.removeFromSuperview() })
    views.forEach({ (view) in self.addSubview(view) })
    self.needsUpdateConstraints = true
    
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
//    self.init(frame: <#T##NSRect#>)
    
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    self.layoutKeys()
  }
  
  func layoutKeys() {
    if let keyViews = self.keyViews {
      
      for (index, view) in keyViews.enumerated() {
        
        let leading = index > 0 ? keyViews[index - 1] : nil
        view.mas_makeConstraints { (make) in
          if let leading = leading {
            make?.left.equalTo()(leading.mas_right)?.offset()(10)
          }
          make?.top.equalTo()(self.mas_top)?.offset()(10)
        }
      }
      guard let firstView = keyViews.first else { return }
      firstView.mas_makeConstraints({ (make) in
        make?.height.equalTo()( firstView.mas_width )
        make?.height.equalTo()( Array(keyViews[1...(keyViews.count - 1)]) )
        make?.width.equalTo()( Array(keyViews[1...(keyViews.count - 2)]) )
      })
    }
    
  }
  
  func pressedAppButton(_ sender : NRNumpadKeyView) {
    if let identifier = sender.identifier, let code = UInt(identifier) {
      self.viewModel?.pressedKey(forKeycode: code)
    }
  }

}

