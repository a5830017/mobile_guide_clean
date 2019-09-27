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
    func presentFeature(response: MobileList.FeatureMobile.Response)
    func presentRemove(response: MobileList.FeatureMobile.Response)
    //    func presentMobile(response: MobileList.FeatureMobile.Response)
    //    func presentFavouriteMobile(response: MobileList.FeatureMobile.Response)
}

class MobileListPresenter: MobileListPresenterInterface {
    weak var viewController: MobileListViewControllerInterface!
    var mobileList: [DisplayMobileList] = []
    var favList: [DisplayMobileList] = []
    
    // MARK: - Presentation logic
    
    func presentSomething(response: MobileList.GetMobile.Response) {
        let result: Result<[DisplayMobileList], Error>
        
        switch response.result {
        case .success(let mobiles):
            var mobileViewModel: [DisplayMobileList] = []
            mobileViewModel = mobiles.map({ (mobile) -> DisplayMobileList in
                let name = mobile.name
                let url = mobile.thumbImageURL
                let brand = mobile.brand
                let price = "price : $\(mobile.price)"
                let rating = "rating : \(mobile.rating)"
                let isFav = mobile.isFavourite ?? false
                let id = mobile.id
                let desc = mobile.description
                return DisplayMobileList(thumbImageURL: url, brand: brand, price: price, description: desc, name: name, rating: rating, isFav: isFav, id: id)
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
    
    func presentFeature(response: MobileList.FeatureMobile.Response) {
        let result = response.result
        mobileList = result.map({ (mobile) -> DisplayMobileList in
            let name = mobile.name
            let price = "price : $\(mobile.price)"
            let rating = "rating : \(mobile.rating)"
            let url = mobile.thumbImageURL
            let brand = mobile.brand
            let isFav = mobile.isFavourite ?? false
            let id = mobile.id
            let desc = mobile.description
            return DisplayMobileList(thumbImageURL: url, brand: brand, price: price, description: desc, name: name, rating: rating, isFav: isFav, id: id)
        })
        let viewModel = MobileList.FeatureMobile.ViewModel(content: mobileList)
        viewController.displayMobile(viewModel: viewModel)
        
    }
    func presentRemove(response: MobileList.FeatureMobile.Response) {
            let result = response.result
            mobileList = result.map({ (mobile) -> DisplayMobileList in
                let name = mobile.name
                let price = "price : $\(mobile.price)"
                let rating = "rating : \(mobile.rating)"
                let url = mobile.thumbImageURL
                let brand = mobile.brand
                let isFav = mobile.isFavourite ?? false
                let id = mobile.id
                let desc = mobile.description
                return DisplayMobileList(thumbImageURL: url, brand: brand, price: price, description: desc, name: name, rating: rating, isFav: isFav, id: id)
            })
            let viewModel = MobileList.FeatureMobile.ViewModel(content: mobileList)
            viewController.displayRemoveMobile(viewModel: viewModel)
            
    }
}
