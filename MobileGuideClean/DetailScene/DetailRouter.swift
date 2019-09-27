//
//  DetailRouter.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailRouterInput {
  func navigateToSomewhere()
}

class DetailRouter: DetailRouterInput {
  weak var viewController: DetailViewController!

  // MARK: - Navigation

  func navigateToSomewhere() {
  }

  // MARK: - Communication

  func passDataToNextScene(segue: UIStoryboardSegue) {
    if segue.identifier == "ShowSomewhereScene" {
      passDataToSomewhereScene(segue: segue)
    }
  }

  func passDataToSomewhereScene(segue: UIStoryboardSegue) {
    
  }
}
