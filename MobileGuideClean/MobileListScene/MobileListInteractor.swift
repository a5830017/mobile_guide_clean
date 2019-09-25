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
    var model: [MobileModel]? { get }
    var favList: [MobileModel] { get set }
}

class MobileListInteractor: MobileListInteractorInterface {
    var presenter: MobileListPresenterInterface!
    var worker: MobileListWorker?
    var model: [MobileModel]?
    var favList: [MobileModel] = []
    var url: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    // MARK: - Business logic
    
    func doSomething(request: MobileList.GetMobile.Request) {
        worker?.getMobileList(url: url) { [weak self] response in
            switch response {
            case .success(let mobile):
                self?.model = mobile
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
        switch request.sortType {
        case .priceLowToHigh:
            guard let sorted = model?.sorted(by: { $0.price < $1.price }) else { return }
            let response = MobileList.SortMobile.Response(result: sorted)
            self.presenter.presentSortedMobile(response: response)
        case .priceHighToLow:
            guard let sorted = model?.sorted(by: { $0.price > $1.price }) else { return }
            let response = MobileList.SortMobile.Response(result: sorted)
            self.presenter.presentSortedMobile(response: response)
        case .rating:
            guard let sorted = model?.sorted(by: { $0.rating > $1.rating }) else { return }
            let response = MobileList.SortMobile.Response(result: sorted)
            self.presenter.presentSortedMobile(response: response)
            
        }
    }
    
    func favMobile(request: MobileList.SwitchSegment.Request) {
        switch request.segmentState {
        case .all:
            let response = MobileList.SwitchSegment.Response(result: model ?? [])
            self.presenter.presentFavouriteMobile(response: response)
        case .favourite:
            guard let favList = model?.filter({ $0.isFavourite! == true }) else { return }
            let response = MobileList.SwitchSegment.Response(result: favList)
            self.presenter.presentFavouriteMobile(response: response)
        }
    }
}
