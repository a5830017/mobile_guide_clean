//
//  MobileListInteractor.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 26/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListInteractorInterface {
    func getMobileListApi(request: MobileList.GetMobile.Request)
    func check(request: MobileList.FeatureMobile.Request)
    func removeFav(request: MobileList.rmId.Request)
    func setFav(request: MobileList.FavId.Request)
    var segmentState: SegmentState? { get set }
    var sortType: SortType? { get set }
    
    
}

class MobileListInteractor: MobileListInteractorInterface {
    
    var presenter: MobileListPresenterInterface!
    var worker: MobileListWorker?
    var model: [MobileModel]?
    var mobileList: [MobileModel] = []
    var favList: [MobileModel] = []
    var url: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    var segmentState: SegmentState?
    var sortType: SortType?
    
    // MARK: - Business logic
    
    func getMobileListApi(request: MobileList.GetMobile.Request) {
        worker?.getMobileList(url: url) { [weak self] response in
            switch response {
            case .success(let mobile):
                self?.mobileList = mobile
                let result: Result<[MobileModel], Error> = .success(mobile)
                let response = MobileList.GetMobile.Response(result: result)
                self?.presenter.presentDataFromApi(response: response)
            case .failure(let error):
                let result: Result<[MobileModel], Error> = .failure(error)
                let response = MobileList.GetMobile.Response(result: result)
                self?.presenter.presentDataFromApi(response: response)
                print(error)
            }
        }
    }
    
    func setFav(request: MobileList.FavId.Request) {
        
        guard let index = mobileList.firstIndex(where: { $0.id == request.id }) else { return }
        let isFavChange = mobileList[index].isFavourite
        mobileList[index].isFavourite = !(isFavChange ?? false)
        favList = mobileList.filter{ $0.isFavourite == true }
        let response = MobileList.FeatureMobile.Response(result: mobileList)
        self.presenter.presentFeature(response: response)
        
    }
    
    func removeFav(request: MobileList.rmId.Request) {
        let favId = request.id
        
        guard let index = mobileList.firstIndex(where: { $0.id == favId}) else { return }
        mobileList[index].isFavourite = request.isFav
        favList = mobileList.filter{ $0.isFavourite == true }
        let response = MobileList.FeatureMobile.Response(result: favList)
        self.presenter.presentRemove(response: response)
    }
    
    
    func check(request: MobileList.FeatureMobile.Request){
        segmentState = request.segmentState
        sortType = request.sortType
        if (segmentState == .all) {
            if(sortType == .isDefault){
//                let response = MobileList.FeatureMobile.Response(result: mobileList)
//                self.presenter.presentFeature(response: response)
                mobileList = sort(type: .isDefault, array: mobileList)
                favList = sort(type: .isDefault, array: favList)
            } else if (sortType == .priceLowToHigh){
                mobileList = sort(type: .priceLowToHigh, array: mobileList)
                favList = sort(type: .priceLowToHigh, array: favList)
            } else if (sortType == .priceHighToLow) {
                mobileList = sort(type: .priceHighToLow, array: mobileList)
                favList = sort(type: .priceHighToLow, array: favList)
                
//                mobileList = mobileList.sorted(by: { $0.price > $1.price })
//                favList = favList.sorted(by: { $0.price > $1.price })
            } else { // rating
                mobileList = sort(type: .rating, array: mobileList)
                favList = sort(type: .rating, array: favList)
//                mobileList = mobileList.sorted(by: { $0.rating > $1.rating })
//                favList = favList.sorted(by: { $0.rating > $1.rating })
            }
            
            let response = MobileList.FeatureMobile.Response(result: mobileList)
            self.presenter.presentFeature(response: response)
        } else { // segmentState == .favourite
//            filterFav()
            if(sortType == .isDefault){
//                let response = MobileList.FeatureMobile.Response(result: favList)
//                self.presenter.presentFeature(response: response)
                mobileList = sort(type: .isDefault, array: mobileList)
                favList = sort(type: .isDefault, array: favList)
            } else if (sortType == .priceLowToHigh) {
                mobileList = sort(type: .priceLowToHigh, array: mobileList)
                favList = sort(type: .priceLowToHigh, array: favList)
            } else if (sortType == .priceHighToLow) {
                mobileList = sort(type: .priceHighToLow, array: mobileList)
                favList = sort(type: .priceHighToLow, array: favList)
            } else { // rating
                mobileList = sort(type: .rating, array: mobileList)
                favList = sort(type: .rating, array: favList)
            }
            
            let response = MobileList.FeatureMobile.Response(result: favList)
            self.presenter.presentFeature(response: response)
        }
    }
    
    func sort(type: SortType, array: [MobileModel]) -> [MobileModel]{
        switch type {
        case .priceLowToHigh:
            return array.sorted(by: { $0.price < $1.price })
            
        case .priceHighToLow:
            return array.sorted(by: { $0.price > $1.price })
            
        case .rating:
            return array.sorted(by: { $0.rating > $1.rating })
            
        case .isDefault:
            return array
        }
    }
}
