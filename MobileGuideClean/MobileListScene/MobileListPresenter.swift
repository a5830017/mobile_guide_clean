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
    func presentSortedMobile(response: MobileList.SortMobile.Response)
    func presentFavouriteMobile(response: MobileList.SwitchSegment.Response)
}

class MobileListPresenter: MobileListPresenterInterface {
    weak var viewController: MobileListViewControllerInterface!
    
    // MARK: - Presentation logic
    
    func presentSomething(response: MobileList.GetMobile.Response) {
        let result: Result<[DisplayMobileList], Error>
        
        switch response.result {
        case .success(let mobiles):
            var mobileViewModel: [DisplayMobileList] = []
            mobileViewModel = mobiles.map({ (mobile) -> DisplayMobileList in
                let name = mobile.name
                let price = "price : $\(mobile.price)"
                let rating = "rating : \(mobile.rating)"
                let isFav = mobile.isFavourite ?? false
                return DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav)
            })
//            for mobile in mobiles{
//                let name = mobile.name
//                let price = "price : $\(mobile.price)"
//                let rating = "rating : \(mobile.rating)"
//
//                let setToMobileViewModel = DisplayMobileList(price: price, name: name, rating: rating)
//
//                mobileViewModel.append(setToMobileViewModel)
//            }
            result = .success(mobileViewModel)
        case .failure(let error):
            result = .failure(error)
        }
        let viewModel = MobileList.GetMobile.ViewModel(content: result)
        viewController.displaySomething(viewModel: viewModel)
    }
    
    func presentSortedMobile(response: MobileList.SortMobile.Response) {
        let sorted = response.result
        var sortedMobile: [DisplayMobileList] = []
        for mobile in sorted {
            let name = mobile.name
            let price = "price : $\(mobile.price)"
            let rating = "rating : \(mobile.rating)"
            let isFav = mobile.isFavourite ?? false
            
            let setToSortViewModel = DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav)
            
            sortedMobile.append(setToSortViewModel)
        }
        let viewModel = MobileList.SortMobile.ViewModel(content: sortedMobile)
        viewController.displaySortedMobile(viewModel: viewModel)
    }
    
    func presentFavouriteMobile(response: MobileList.SwitchSegment.Response) {
        let fav = response.result
        var favList: [DisplayMobileList] = []
        favList = fav.map({ (mobile) -> DisplayMobileList in
            let name = mobile.name
            let price = "price : $\(mobile.price)"
            let rating = "rating : \(mobile.rating)"
            let isFav = mobile.isFavourite ?? false
            return DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav)
        })
        let viewModel = MobileList.SwitchSegment.ViewModel(content: favList)
        viewController.displayFavouriteMobile(viewModel: viewModel)
    }
}
