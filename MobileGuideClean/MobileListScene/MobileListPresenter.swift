//
//  MobileListPresenter.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListPresenterInterface {
  func presentSomething(response: MobileList.GetMobile.Response)
}

class MobileListPresenter: MobileListPresenterInterface {
  weak var viewController: MobileListViewControllerInterface!

  // MARK: - Presentation logic

  func presentSomething(response: MobileList.GetMobile.Response) {
    let result: Result<[MobileList.GetMobile.ViewModel.DisplayMobileList], Error>
    
    switch response.result {
    case .success(let mobiles):
        var mobileViewModel: [MobileList.GetMobile.ViewModel.DisplayMobileList] = []
        for mobile in mobiles{
            let name = mobile.name
            let price = "price : $\(mobile.price)"
            let rating = "rating : \(mobile.rating)"
            
            let setToMobileViewModel = MobileList.GetMobile.ViewModel.DisplayMobileList(price: price, name: name, rating: rating)
            
            mobileViewModel.append(setToMobileViewModel)
        }
        result = .success(mobileViewModel)
    case .failure(let error):
        result = .failure(error)
    }
    let viewModel = MobileList.GetMobile.ViewModel(content: result)
    viewController.displaySomething(viewModel: viewModel)
  }
}
