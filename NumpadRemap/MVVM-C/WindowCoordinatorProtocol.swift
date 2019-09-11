//
//  WindowCoordinatorProtocol.swift
//  Flashcard Snapper
//
//  Created by David Belford on 2/22/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation
import AppKit

protocol WindowCoordinator : AnyObject {
  var windowController : NSWindowController { get }
//  var contentCoordinator : Coordinator? { get }
  
  func presentWindow() // AKA Start
}
