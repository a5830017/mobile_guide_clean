//
//  DetailInteractor.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailInteractorInterface {
    func doSomething(request: Detail.Something.Request)
    var model: [ImageModel]? { get }
    var mobile: MobileModel? { get set }
}

class DetailInteractor: DetailInteractorInterface {
    var presenter: DetailPresenterInterface!
    var worker: DetailWorker?
    var model: [ImageModel]?
    var mobile: MobileModel?
    var mobileId : String = ""
    
    // MARK: - Business logic
    
    func doSomething(request: Detail.Something.Request) {
        mobileId = "\(mobile?.id ?? 1)"
        let url: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/\(mobileId)/images/"
        
        worker?.getImg(url: url) { [weak self] response in
            switch response {
            case .success(let mobile):
                self?.model = mobile
                let result: Result<[ImageModel], Error> = .success(mobile)
                let response = Detail.Something.Response(result: result)
                self?.presenter.presentSomething(response: response)
            case .failure(let error):
                let result: Result<[ImageModel], Error> = .failure(error)
                let response = Detail.Something.Response(result: result)
                self?.presenter.presentSomething(response: response)
                print(error)
            }
        }
        //        worker?.doSomeWork { [weak self] in
        //            if case let Result.success(data) = $0 {
        //                // If the result was successful, we keep the data so that we can deliver it to another view controller through the router.
        //                self?.model = data
        //            }
        //
        //            // NOTE: Pass the result to the Presenter. This is done by creating a response model with the result from the worker. The response could contain a type like UserResult enum (as declared in the SCB Easy project) with the result as an associated value.
        //            let response = Detail.Something.Response()
        //            self?.presenter.presentSomething(response: response)
        //        }
        //    }
    }
}
