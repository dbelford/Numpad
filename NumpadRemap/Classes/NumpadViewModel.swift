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

class NumpadViewModel : NSObject, NumpadViewModelActions {

  
  @IBOutlet var model : ShortcutMappingModel?
  var numpadKeys : [NumpadKeyViewModel] = []
  var keyImages : [NSImage] = []
  var displayNames : [String] = []
  var keyNames : [String] = []
  
  //keycodeActivatedSignal
  var hideNumpadNumbers : Bool = false
  var observers = [NSKeyValueObservation]()

  init(model : ShortcutMappingModel) {
    self.model = model
    super.init()
    observers.append(self.observe(\NumpadViewModel.model?.shortcuts) { [weak self] (model, changes) in
      self?.numpadKeys = self?.model?.shortcuts.map({ (shortcut) -> NumpadKeyViewModel in
        return NumpadKeyViewModel(shortcut: shortcut, identifier: shortcut.keyCodeString)
      }) ?? []
      self?.updateFromModel()
    })
    observers.append(self.observe(\NumpadViewModel.model) { [weak self] (model, changes) in
      self?.updateFromModel()
    })
    observers.append(self.observe(\NumpadViewModel.model?.hideNumpadNumbers) { [weak self] (model, changes) in
      self?.updateFromModel()
    })
  }

  func updateFromModel() {
    self.hideNumpadNumbers = self.model?.hideNumpadNumbers ?? true
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

