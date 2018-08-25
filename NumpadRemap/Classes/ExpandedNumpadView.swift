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
//        NSLog("The change: \(view) \(change)")
        guard let strongSelf = self else { return }
        strongSelf.updateKeys()
      }
    }
    
  }
  var keyViewsGrid: [[NRNumpadKeyView]]?
  var keyViews : [NRNumpadKeyView]?
  var keyViewsSignal : RACSignal!
  var vmObserver : NSKeyValueObservation!
  
  override var acceptsFirstResponder: Bool {
    get { return true }
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
  
  struct KeyAttributes {
    var width : CGFloat = 1
    var height : CGFloat = 1
    var assignable : Bool = true
    var visible : Bool = true
    var emptyTrailing: Bool = false
    
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
  }
  
  lazy var keyProperties : [Int : KeyAttributes] = {
    return [
      kVK_ANSI_KeypadClear : KeyAttributes.init(assignable: false, visible: false),
      kVK_ANSI_Keypad0 : KeyAttributes(width: 2, height: 1),
      kVK_ANSI_KeypadEnter : KeyAttributes(width: 1, height: 2),
      kVK_ANSI_KeypadDecimal : KeyAttributes(doesNotHaveTrailing: true)
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
//
//
//
//    if case self = self {
//      vmObserver = self.observe(\ExpandedNumpadView.viewModel?) { (view, change) in
//        NSLog("The change: \(change.newValue)")
//      }
//    }
    self.wantsLayer = true
    
  }
  
  // TODO: Don't destroy keys on every update, reuse views
  //       or maintain some state.
  //       Updates caused by app recency order changes, apps
  //       closing, apps opening, keyboard presentation style changing
  
  func updateKeys() {
    var views : [NRNumpadKeyView] = []
    var gridViews : [[NRNumpadKeyView]] = []
    guard let keyViewModels = self.viewModel?.numpadKeys else { return }
    for (_, row) in self.keyOrder.enumerated() {
      var rowOfViews : [NRNumpadKeyView]  = []
      for (keyIndex, keyCode) in row.enumerated() {
        let view = NRNumpadKeyView.init(frame: NSMakeRect(0, 0, 400, 400))
        let vm = keyViewModels.first(where: { (keyViewModel) -> Bool in
          return keyViewModel.shortcut.keyCode == keyCode
        })
        view.viewModel = vm
        
        view.addTarget(self, action: #selector(ExpandedNumpadView.pressedAppButton), for: BTRControlEvents.mouseUpInside)
        
//        _ = RACObserve(target: NRPreferences.sharedInstance(), #keyPath(NRPreferences.hideNumpadNumbers)) ~> RAC(view.keyLabel, #keyPath(BTRLabel.isHidden))
//        _ = RACObserve(target: self, #keyPath(ExpandedNumpadView.viewModel.hideNumpadNumbers)) ~> RAC(self, #keyPath(ExpandedNumpadView.hideNumpadNumbers))
        
        
        rowOfViews.append(view)
        views.append(view)
      }
      gridViews.append(rowOfViews)
    }
//    let views = keyViewModels.map { (vm : NRNumpadKeyViewModel) -> NRNumpadKeyView in
//      let view = NRNumpadKeyView.init(frame: NSMakeRect(0, 0, 400, 400))
//      view.iconImageView.image = vm.image
//      view.keyLabel.stringValue = vm.keyName
//      view.identifier = String.init(vm.shortcut.keyCode)
//      view.addTarget(self, action: #selector(ExpandedNumpadView.pressedAppButton), for: BTRControlEvents.mouseUpInside)
//
//      _ = RACObserve(target: NRPreferences.sharedInstance(), #keyPath(NRPreferences.hideNumpadNumbers)) ~> RAC(view.keyLabel, #keyPath(BTRLabel.isHidden))
//
//      return view
//    }
    self.keyViewsGrid = gridViews
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
    self.layoutKeys3()
  }
  
  func layoutKeys3() {
    
    guard let keyViews = self.keyViews else { return }
    guard let keyViewsGrid = self.keyViewsGrid else { return }
    guard let firstView = keyViews.first else { return }
    var previousRow : [NRNumpadKeyView]?
    for (rowIndex, row) in keyViewsGrid.enumerated() {
      let aboveView = previousRow?.first
      for (keyIndex, view) in row.enumerated() {
        let keyCode = self.keyOrder[rowIndex][keyIndex]
        let dontPinRight = keyProperties[keyCode]?.emptyTrailing ?? false
        let leading = keyIndex == 0 ? nil : row[keyIndex - 1]
        view.mas_makeConstraints { (make) in
          make?.left.equalTo()(leading?.mas_right ?? self.mas_left)
          make?.top.equalTo()(aboveView?.mas_bottom ?? self.mas_top)
          if ((keyIndex + 1 == row.count) && ( !dontPinRight )) {
            make?.right.equalTo()(self.mas_right)
          }
          if (rowIndex + 1 == keyViewsGrid.count) {
            make?.bottom.equalTo()(self.mas_bottom)
          }
          if view != firstView {
            if let heightMultiplier = keyProperties[keyCode]?.height {
              make?.height.equalTo()(firstView.mas_height)?.multipliedBy()(heightMultiplier)
            } else {
              make?.height.equalTo()(firstView.mas_height)
            }
            
            if let widthMultiplier = keyProperties[keyCode]?.width {
              make?.width.equalTo()(firstView.mas_width)?.multipliedBy()(widthMultiplier)
            } else {
              make?.width.equalTo()(firstView.mas_width)
            }
          }
        }
      }
      previousRow = row
    }
    
    firstView.mas_makeConstraints({ (make) in
      //      let equalSized = keyViews.filter({ (view) -> Bool in
      //        if let prop = keyProperties[keyCode] { view.isHidden = !prop.visible }
      //      })
      make?.height.equalTo()( firstView.mas_width )
      //      make?.height.equalTo()( Array(keyViews[1...(keyViews.count - 1)]) )
      //      make?.width.equalTo()( Array(keyViews[1...(keyViews.count - 2)]) )
    })
  }
  
  // TODO: Fix layout to not use offset/padding between keys.
  //       Everything should be boxes so multiplier works better
  //       Then insert padding inside key on keybackground layer
  
  func layoutKeys2() {
    guard let keyViews = self.keyViews else { return }
    guard let keyViewsGrid = self.keyViewsGrid else { return }
    guard let firstView = keyViews.first else { return }
    var previousRow : [NRNumpadKeyView]?
    for (rowIndex, row) in keyViewsGrid.enumerated() {
//      let leadingView = row[0]
      let aboveView = previousRow?.first
//      leadingView.mas_makeConstraints { (make) in
//        make?.left.equalTo()(self.mas_left)?.offset()(7)
//        make?.top.equalTo()(aboveView?.mas_bottom ?? self.mas_top)?.offset()(7)
//      }
      for (keyIndex, view) in row.enumerated() {
        let keyCode = self.keyOrder[rowIndex][keyIndex]
        let dontPinRight = keyProperties[keyCode]?.emptyTrailing ?? false
        let leading = keyIndex == 0 ? nil : row[keyIndex - 1]
        view.mas_makeConstraints { (make) in
          make?.left.equalTo()(leading?.mas_right ?? self.mas_left)?.offset()(10)
          make?.top.equalTo()(aboveView?.mas_bottom ?? self.mas_top)?.offset()(10)
          if ((keyIndex + 1 == row.count) && ( !dontPinRight )) {
            make?.right.equalTo()(self.mas_right)?.inset()(10)
          }
          if (rowIndex + 1 == keyViewsGrid.count) {
            make?.bottom.equalTo()(self.mas_bottom)?.inset()(10)
          }
          
          if view != firstView {
            if let heightMultiplier = keyProperties[keyCode]?.height {
              make?.height.equalTo()(firstView.mas_height)?.multipliedBy()(heightMultiplier)?.offset()(heightMultiplier > 1 ? 10 : 0)
            } else {
              make?.height.equalTo()(firstView.mas_height)
            }
            
            if let widthMultiplier = keyProperties[keyCode]?.width {
              make?.width.equalTo()(firstView.mas_width)?.multipliedBy()(widthMultiplier)?.offset()(widthMultiplier > 1 ? 10 : 0)
            } else {
              make?.width.equalTo()(firstView.mas_width)
            }
          }
        }
        
        
      }
      previousRow = row
    }
    
    firstView.mas_makeConstraints({ (make) in
//      let equalSized = keyViews.filter({ (view) -> Bool in
//        if let prop = keyProperties[keyCode] { view.isHidden = !prop.visible }
//      })
      make?.height.equalTo()( firstView.mas_width )
//      make?.height.equalTo()( Array(keyViews[1...(keyViews.count - 1)]) )
//      make?.width.equalTo()( Array(keyViews[1...(keyViews.count - 2)]) )
    })
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

