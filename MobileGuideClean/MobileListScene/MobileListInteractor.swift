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
    var model: [MobileModel]? { get }
}

class MobileListInteractor: MobileListInteractorInterface {
    var presenter: MobileListPresenterInterface!
    var worker: MobileListWorker?
    var model: [MobileModel]?
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
}
