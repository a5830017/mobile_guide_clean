//
//  DetailModels.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

struct DisplayMobileDetail {
    let url : String
    let mobileId : Int
    let id : Int
}

struct Detail {
  /// This structure represents a use case
  struct Something {
    /// Data struct sent to Interactor
    struct Request {
        
    }
    /// Data struct sent to Presenter
    struct Response {
        let result: Result<[ImageModel], Error>
        var mobile: DisplayMobileList
    }
    /// Data struct sent to ViewController
    struct ViewModel {
        let content: Result<[DisplayMobileDetail], Error>
        var mobile: DisplayMobileList
    }
  }
}
