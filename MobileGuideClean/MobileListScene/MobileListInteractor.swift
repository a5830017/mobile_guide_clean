//
//  MobileListInteractor.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListInteractorInterface {
    func doSomething(request: MobileList.GetMobile.Request)
    func sortMobile(request: MobileList.SortMobile.Request)
    func favMobile(request: MobileList.SwitchSegment.Request)
    func setFav(request: MobileList.FavId.Request)
    var model: [MobileModel]? { get }
}

class MobileListInteractor: MobileListInteractorInterface {
    var presenter: MobileListPresenterInterface!
    var worker: MobileListWorker?
    var model: [MobileModel]?
    var mobileList: [MobileModel] = []
    var favList: [MobileModel] = []
    var url: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    var segmentState: SegmentState = .all
    var sortType: SortType = .priceHighToLow
//    var mobileIndex: Int = 0
    // MARK: - Business logic
    
    func doSomething(request: MobileList.GetMobile.Request) {
        worker?.getMobileList(url: url) { [weak self] response in
            switch response {
            case .success(let mobile):
                self?.model = mobile
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
    
    func sortMobile(request: MobileList.SortMobile.Request) {
        sortType = request.sortType
        switch sortType {
        case .priceLowToHigh:
//            guard let sorted = model?.sorted(by: { $0.price < $1.price }) else { return }
//            if segmentState == .all {
//                let response = MobileList.SortMobile.Response(result: sorted)
//                self.presenter.presentSortedAllMobile(response: response)
//            } else {
//                let response = MobileList.SwitchSegment.Response(result: sorted)
//                self.presenter.presentFavouriteMobile(response: response)
//            }
            
            if segmentState == .all {
                let sorted = mobileList.sorted(by: { $0.price < $1.price })
                mobileList = sorted
                let response = MobileList.SortMobile.Response(result: sorted)
                self.presenter.presentMobile(response: response)
            } else {
                let sorted = favList.sorted(by: { $0.price < $1.price })
                favList = sorted
                let response = MobileList.SwitchSegment.Response(result: sorted)
                self.presenter.presentFavouriteMobile(response: response)
            }
            
        case .priceHighToLow:
//            guard let sorted = model?.sorted(by: { $0.price > $1.price }) else { return }
//            let response = MobileList.SortMobile.Response(result: sorted)
//            self.presenter.presentSortedMobile(response: response)
            
            if segmentState == .all {
                let sorted = mobileList.sorted(by: { $0.price < $1.price })
                mobileList = sorted
                let response = MobileList.SortMobile.Response(result: sorted)
                self.presenter.presentMobile(response: response)
            } else {
                let sorted = favList.sorted(by: { $0.price < $1.price })
                favList = sorted
                let response = MobileList.SwitchSegment.Response(result: sorted)
                self.presenter.presentFavouriteMobile(response: response)
            }
            
        case .rating:
//            guard let sorted = model?.sorted(by: { $0.rating > $1.rating }) else { return }
//            let response = MobileList.SortMobile.Response(result: sorted)
//            self.presenter.presentSortedMobile(response: response)
            if segmentState == .all {
                let sorted = mobileList.sorted(by: { $0.price < $1.price })
                mobileList = sorted
                let response = MobileList.SortMobile.Response(result: sorted)
                self.presenter.presentMobile(response: response)
            } else {
                let sorted = favList.sorted(by: { $0.price < $1.price })
                favList = sorted
                let response = MobileList.SwitchSegment.Response(result: sorted)
                self.presenter.presentFavouriteMobile(response: response)
            }
            
        }
    }
    
    func favMobile(request: MobileList.SwitchSegment.Request) {
        segmentState = request.segmentState
        switch request.segmentState {
        case .all:
            let response = MobileList.SortMobile.Response(result: mobileList)
            self.presenter.presentMobile(response: response)
        case .favourite:
            favList = mobileList.filter{ $0.isFavourite == true }
            print("segment : \(mobileList)")
            let response = MobileList.SwitchSegment.Response(result: favList)
            self.presenter.presentFavouriteMobile(response: response)
        }
    }
    
    func setFav(request: MobileList.FavId.Request) {
        guard let model = model,
            let index = model.firstIndex(where: { $0.id == request.id }) else {
            return
        }
//        let index = mobileList.firstIndex(where: { $0.id == request.id })
        
        mobileList[index].isFavourite = !(mobileList[index].isFavourite ?? true)
//        guard var modelIndex = model[index].isFavourite else { return }
//        if(modelIndex == false){
//            modelIndex = true
//        } else {
//            modelIndex = false
//        }
//        model[index].isFavourite = modelIndex
//        print("\(model[index].isFavourite)")
        print("button click : \(mobileList)")
        
//        model[index].isFavourite = !(model[index].isFavourite ?? false)
//        mobileList = model
//        print("index : \(index)")
        
    }
}
