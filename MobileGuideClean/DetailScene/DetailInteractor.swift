//
//  DetailInteractor.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailInteractorInterface {
    func getImgData(request: Detail.Something.Request)
    var model: [ImageModel]? { get }
    var mobile: DisplayMobileList? { get set }
}

class DetailInteractor: DetailInteractorInterface {
    var presenter: DetailPresenterInterface!
    var worker: DetailWorker?
    var model: [ImageModel]?
    var mobile: DisplayMobileList?
    var mobileId : Int?
    
    // MARK: - Business logic
    
    func getImgData(request: Detail.Something.Request) {
        guard let mobileId = mobile?.id else { return }
        let url: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/\(mobileId)/images/"
        
        worker?.getImg(url: url) { [weak self] response in
            switch response {
            case .success(let mobile):
                self?.model = mobile
                let result: Result<[ImageModel], Error> = .success(mobile)
                guard let mobileData = self?.mobile else { return }
                let response = Detail.Something.Response(result: result, mobile: mobileData)
                self?.presenter.presentImg(response: response)
            case .failure(let error):
                let result: Result<[ImageModel], Error> = .failure(error)
                guard let mobileData = self?.mobile else { return }
                let response = Detail.Something.Response(result: result, mobile: mobileData)
                self?.presenter.presentImg(response: response)
                print(error)
            }
        }
    }
}
