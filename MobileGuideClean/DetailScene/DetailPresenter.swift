//
//  DetailPresenter.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailPresenterInterface {
    func presentImg(response: Detail.Something.Response)
}

class DetailPresenter: DetailPresenterInterface {
    weak var viewController: DetailViewControllerInterface!
    
    // MARK: - Presentation logic
    
    func presentImg(response: Detail.Something.Response) {
        let mobileData = response.mobile
        let result: Result<[DisplayMobileDetail], Error>
        
        switch response.result {
        case .success(let mobiles):
            var mobileViewModel: [DisplayMobileDetail] = []
            mobileViewModel = mobiles.map({ (mobile) -> DisplayMobileDetail in
                let url = mobile.url
                let id = mobile.id
                let mobileId = mobile.mobileId
                return DisplayMobileDetail(url: url, mobileId: mobileId, id: id)
            })
            result = .success(mobileViewModel)
            let viewModel = Detail.Something.ViewModel(content: result, mobile: mobileData)
            viewController.displayImgFromApi(viewModel: viewModel)
        case .failure(let error):
            result = .failure(error)
            let viewModel = Detail.Something.ViewModel(content: result, mobile: mobileData)
            viewController.displayImgFromApi(viewModel: viewModel)
        }
        let viewModel = Detail.Something.ViewModel(content: result, mobile: mobileData)
        viewController.displayImgFromApi(viewModel: viewModel)
        
    }
}
