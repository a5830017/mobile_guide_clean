//
//  DetailPresenter.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailPresenterInterface {
  func presentSomething(response: Detail.Something.Response)
}

class DetailPresenter: DetailPresenterInterface {
  weak var viewController: DetailViewControllerInterface!

  // MARK: - Presentation logic

  func presentSomething(response: Detail.Something.Response) {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller. The resulting view model should be using only primitive types. Eg: the view should not need to involve converting date object into a formatted string. The formatting is done here.

    let viewModel = Detail.Something.ViewModel()
    viewController.displaySomething(viewModel: viewModel)
  }
}
