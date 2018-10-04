//
//  NumpadViewModel.swift
//  Numpad
//
//  Created by David Belford on 9/5/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

protocol NumpadViewModelActions {
  func pressedKeyForKeycode(keycode : UInt)
}

@objc
class NumpadViewModel : NSObject, NumpadViewModelActions {

  
  @IBOutlet var model : ShortcutMappingModel? {
    didSet {
      self.setupModel()
    }
  }
  @objc dynamic var numpadKeys : [NumpadKeyViewModel] = []
  @objc dynamic var keyboardType : String
//  var keyImages : [NSImage] = []
//  var displayNames : [String] = []
//  var keyNames : [String] = []
  
  //keycodeActivatedSignal
  @objc dynamic var hideNumpadNumbers : Bool = false
  var observers = [NSKeyValueObservation]()
  
  override init() {
    self.keyboardType = KeyboardTypes.numbers.rawValue//0
    super.init()

  }

  init(model : ShortcutMappingModel) {
    self.model = model
    self.keyboardType = KeyboardTypes.numbers.rawValue//0
    super.init()
    self.setupModel()
  }
  
  func setupModel() {
    self.model?.onModelUpdated({ [weak self] (property) in
      if case .keyboardType = property {
        self?.keyboardType = self?.model?.keyboardType.rawValue ?? KeyboardTypes.numbers.rawValue
      }
//      if case .shortcuts = property {
//        self?.buildKeys()
//      }
      self?.buildKeys()
      self?.updateFromModel()
    })
    self.buildKeys()
    self.updateFromModel()
  }
  
  func buildKeys() {
    self.numpadKeys = self.model?.shortcuts.map({ (shortcut) -> NumpadKeyViewModel in
      return NumpadKeyViewModel(shortcut: shortcut, identifier: shortcut.keyCodeString)
    }) ?? []
  }

  func updateFromModel() {
    self.hideNumpadNumbers = self.model?.hideNumpadNumbers ?? true
    self.keyboardType = self.model?.keyboardType.rawValue ?? KeyboardTypes.numbers.rawValue
    for vm in self.numpadKeys {
      vm.hideNumpadNumbers = self.hideNumpadNumbers
    }
  }
  
  typealias KeyPressHandler = (UInt) -> Void
  var keyPressedHandlers = [KeyPressHandler]()
  func onPressedKeyForKeycode(handler : @escaping KeyPressHandler) {
    keyPressedHandlers.append(handler)
  }
  
  func pressedKeyForKeycode(keycode: UInt) {
    for handler in self.keyPressedHandlers {
      handler(keycode)
    }
  }
}

