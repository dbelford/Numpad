//
//  CoordinatorProtocol.swift
//  Flashcard Snapper
//
//  Created by David Belford on 2/22/19.
//  Copyright © 2019 David Belford. All rights reserved.
//

import Foundation

protocol Coordinator : AnyObject {
//  var viewModel : ViewModel { get }
//  var viewController : VMViewController { get }
  var childCoordinators : [Coordinator] { get }
  
  func present() // AKA Start
  
}

//protocol ParentCoordinator : Coordinator {
//
//  var childCoordinators : [Coordinator] { get }
//
//}
