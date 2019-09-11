//
//  VMViewController.swift
//  Flashcard Snapper
//
//  Created by David Belford on 2/22/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation
import Cocoa

class VMViewController : ViewController {
  var viewModel : ViewModel?
  
  func bindViewModel(viewModel : ViewModel) {
    self.viewModel = viewModel
  }
  
}
