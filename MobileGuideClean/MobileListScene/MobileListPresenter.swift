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
                //                let price = "price : $\(mobile.price)"
                //                let rating = "rating : \(mobile.rating)"
                let price = "price : $\(mobile.price)"
                let rating = "rating : \(mobile.rating)"
                let isFav = mobile.isFavourite ?? false
                let id = mobile.id
                return DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav, id: id)
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
            //            let price = "\(mobile.price)"
            //            let rating = "\(mobile.rating)"
            let isFav = mobile.isFavourite ?? false
            let id = mobile.id
            return DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav, id: id)
        })
        let viewModel = MobileList.FeatureMobile.ViewModel(content: mobileList)
        viewController.displayMobile(viewModel: viewModel)
        
}
}

//    func presentMobile(response: MobileList.SortMobile.Response) {
//        let sorted = response.result
//        var sortedMobile: [DisplayMobileList] = []
//        sortedMobile = sorted.map({ (mobile) -> DisplayMobileList in
//            let name = mobile.name
//            let price = "price : $\(mobile.price)"
//            let rating = "rating : \(mobile.rating)"
////            let price = "\(mobile.price)"
////            let rating = "\(mobile.rating)"
//            let isFav = mobile.isFavourite ?? false
//            let id = mobile.id
//            return DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav, id: id)
//        })
//        //        for mobile in sorted {
////            let name = mobile.name
////            let price = "price : $\(mobile.price)"
////            let rating = "rating : \(mobile.rating)"
////            let isFav = mobile.isFav
////
////            let setToSortViewModel = DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav)
////
////            sortedMobile.append(setToSortViewModel)
////        }
//        mobileList = sortedMobile
//        let viewModel = MobileList.SortMobile.ViewModel(content: mobileList)
//        viewController.displayMobile(viewModel: viewModel)
//    }
//
//    func presentFavouriteMobile(response: MobileList.SwitchSegment.Response) {
//        let fav = response.result
//        var favList: [DisplayMobileList] = []
//        favList = fav.map({ (mobile) -> DisplayMobileList in
//            let name = mobile.name
//            let price = "price : $\(mobile.price)"
//            let rating = "rating : \(mobile.rating)"
//            let isFav = mobile.isFavourite ?? false
//            let id = mobile.id
//            return DisplayMobileList(price: price, name: name, rating: rating, isFav: isFav, id: id)
//        })
//        mobileList = favList
//        let viewModel = MobileList.SwitchSegment.ViewModel(content: mobileList)
//        viewController.displayFavouriteMobile(viewModel: viewModel)
//    }
//}
