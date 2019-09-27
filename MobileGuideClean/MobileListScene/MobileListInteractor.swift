//
//  MobileListInteractor.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 26/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListInteractorInterface {
    func doSomething(request: MobileList.GetMobile.Request)
    func check(request: MobileList.FeatureMobile.Request)
    func removeFav(request: MobileList.rmId.Request)
    func setFav(request: MobileList.FavId.Request)
    //    var model: [MobileModel]? { get }
    var mobileList: [MobileModel]? { get set }
    var favList: [MobileModel]? { get set }
    var segmentState: SegmentState? { get set }
    var sortType: SortType? { get set }
    
    
}

class MobileListInteractor: MobileListInteractorInterface {
    
    var presenter: MobileListPresenterInterface!
    var worker: MobileListWorker?
    var model: [MobileModel]?
    var mobileList: [MobileModel]?
    var favList: [MobileModel]?
    var url: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    var segmentState: SegmentState?
    var sortType: SortType?
    //    var dict: Dictionary?
    // MARK: - Business logic
    
    func doSomething(request: MobileList.GetMobile.Request) {
        worker?.getMobileList(url: url) { [weak self] response in
            switch response {
            case .success(let mobile):
                //                self?.model = mobile
                self?.mobileList = mobile
                let result: Result<[MobileModel], Error> = .success(mobile)
                let response = MobileList.GetMobile.Response(result: result)
                self?.presenter.presentSomething(response: response)
            case .failure(let error):
                let result: Result<[MobileModel], Error> = .failure(error)
                let response = MobileList.GetMobile.Response(result: result)
                self?.presenter.presentSomething(response: response)
                print(error)
            }
        }
    }
    
    func setFav(request: MobileList.FavId.Request) {
        guard let model = mobileList,
            let index = model.firstIndex(where: { $0.id == request.id }) else {
                return
        }
        //        let index = mobileList.firstIndex(where: { $0.id == request.id })
        guard let isFavChange = mobileList?[index].isFavourite else {
            return
        }
        mobileList?[index].isFavourite = !isFavChange
        favList = mobileList?.filter{ $0.isFavourite == true }
        let response = MobileList.FeatureMobile.Response(result: mobileList ?? [])
        self.presenter.presentFeature(response: response)
        
    }
    
    func removeFav(request: MobileList.rmId.Request) {
        let favId = request.id
        guard let model = mobileList,
            let index = model.firstIndex(where: { $0.id == favId}) else {
                return
        }
        mobileList?[index].isFavourite = request.isFav
        favList = mobileList?.filter{ $0.isFavourite == true }
        let response = MobileList.FeatureMobile.Response(result: favList ?? [])
        self.presenter.presentRemove(response: response)
    }
    
    
    func check(request: MobileList.FeatureMobile.Request){
        segmentState = request.segmentState
        sortType = request.sortType
        if (segmentState == .all) {
            if(sortType == .isDefault){
                let response = MobileList.FeatureMobile.Response(result: mobileList ?? [])
                self.presenter.presentFeature(response: response)
            } else if (sortType == .priceLowToHigh){
                mobileList = mobileList?.sorted(by: { $0.price < $1.price })
                favList = favList?.sorted(by: { $0.price < $1.price })
            } else if (sortType == .priceHighToLow) {
                mobileList = mobileList?.sorted(by: { $0.price > $1.price })
                favList = favList?.sorted(by: { $0.price > $1.price })
            } else { // rating
                mobileList = mobileList?.sorted(by: { $0.rating > $1.rating })
                favList = favList?.sorted(by: { $0.rating > $1.rating })
            }
            
            let response = MobileList.FeatureMobile.Response(result: mobileList ?? [])
            self.presenter.presentFeature(response: response)
        } else { // segmentState == .favourite
            filterFav()
            if(sortType == .isDefault){
                let response = MobileList.FeatureMobile.Response(result: favList ?? [])
                self.presenter.presentFeature(response: response)
            } else if (sortType == .priceLowToHigh) {
                mobileList = mobileList?.sorted(by: { $0.price < $1.price })
                favList = favList?.sorted(by: { $0.price < $1.price })
            } else if (sortType == .priceHighToLow) {
                mobileList = mobileList?.sorted(by: { $0.price > $1.price })
                favList = favList?.sorted(by: { $0.price > $1.price })
            } else { // rating
                mobileList = mobileList?.sorted(by: { $0.rating > $1.rating })
                favList = favList?.sorted(by: { $0.rating > $1.rating })
            }
            
            let response = MobileList.FeatureMobile.Response(result: favList ?? [])
            self.presenter.presentFeature(response: response)
        }
        
        
    }
    
    //    func checkSort(request: MobileList.FeatureMobile.Request){
    //        sortType = request.sortType
    //    }
    
    func filterFav() {
        favList = mobileList?.filter { $0.isFavourite! == true }
    }
    
}
