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
  var containerView : BTRView!
  
  override var acceptsFirstResponder: Bool {
    get { return true }
  }

  let keyboard = Keyboards.numpad
//  let keyOrder = KeyOrders.Numbers
//  let keyProperties = KeyboardProperties.Numbers
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect, layerHosted: true)
    self.wantsLayer = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.containerView = BTRView(frame: self.bounds, layerHosted: true)
    self.addSubview(self.containerView)
  }
  
  // TODO: Don't destroy keys on every update, reuse views
  //       or maintain some state.
  //       Updates caused by app recency order changes, apps
  //       closing, apps opening, keyboard presentation style changing
  
  func updateKeys() {
    var views : [NRNumpadKeyView] = []
    var gridViews : [[NRNumpadKeyView]] = []
    guard let keyViewModels = self.viewModel?.numpadKeys else { return }
    for (_, row) in self.keyboard.data().keyOrder.enumerated() {
      var rowOfViews : [NRNumpadKeyView]  = []
      for (keyIndex, keyCode) in row.enumerated() {
        var view = NRNumpadKeyView.init(frame: NSMakeRect(0, 0, 20, 20))
        var vm = keyViewModels.first(where: { (keyViewModel) -> Bool in
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
    
//    self.mas_makeConstraints { (make) in
//      make?.edges.equalTo()(self)
////      make?.width.equalTo()(self.mas_width)
////      make?.height.equalTo()(self.mas_height)
//      make?.width.equalTo()(firstView.mas_width)?.multipliedBy()(self.keyboard.data().keyboardWidth)//?.priorityLow()()
//      make?.height.equalTo()(firstView.mas_height)?.multipliedBy()(CGFloat(keyViewsGrid.count))//?.priorityLow()()
//    }
//
    firstView.mas_makeConstraints { (make) in
      make?.width.equalTo()(self.mas_width)?.dividedBy()(self.keyboard.data().keyboardWidth)//?.priorityLow()()
      make?.height.equalTo()(self.mas_height)?.dividedBy()(CGFloat(keyViewsGrid.count))//?.priorityLow()()
    }
    
    for (rowIndex, row) in keyViewsGrid.enumerated() {
      let aboveView = previousRow?.first
      for (keyIndex, view) in row.enumerated() {
        let keyCode = self.keyboard.data().keyOrder[rowIndex][keyIndex]
        
//        let dontPinRight = self.keyboard.data().keyboardProperties[keyCode]?.emptyTrailing ?? false
        
        let leading = keyIndex == 0 ? nil : row[keyIndex - 1]
//        let trailing = keyIndex == row.count - 1 ? nil : row[keyIndex + 1]
        view.mas_makeConstraints { (make) in
          view.setContentCompressionResistancePriority(NSLayoutPriorityDefaultLow, for: .horizontal)
          view.setContentCompressionResistancePriority(NSLayoutPriorityDefaultLow, for: .vertical)
          make?.left.equalTo()(leading?.mas_right ?? self.mas_left)
          make?.top.equalTo()(aboveView?.mas_bottom ?? self.mas_top)

          if view != firstView {
            if let keyProperty = self.keyboard.data().keyboardProperties[keyCode] {
              make?.height.equalTo()(firstView.mas_height)//?.multipliedBy()(keyProperty.height)
              make?.width.equalTo()(firstView.mas_width)?.multipliedBy()(keyProperty.width)
            } else {
              make?.height.equalTo()(firstView.mas_height)
              make?.width.equalTo()(firstView.mas_width)
            }
          }
        }
      }

      previousRow = row
    }

    firstView.mas_makeConstraints({ (make) in
      make?.height.equalTo()( firstView.mas_width )
    })
  }
  
  func pressedAppButton(_ sender : NRNumpadKeyView) {
    if let identifier = sender.identifier, let code = UInt(identifier) {
      self.viewModel?.pressedKey(forKeycode: code)
    }
  }

}

