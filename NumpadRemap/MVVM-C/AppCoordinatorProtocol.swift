//
//  AppCoordinatorProtocol.swift
//  Flashcard Snapper
//
//  Created by David Belford on 2/22/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation

protocol AppCoordinator : AnyObject {
  
  var windowCoordinators : [WindowCoordinator] { get set }
  
  func present()
}
