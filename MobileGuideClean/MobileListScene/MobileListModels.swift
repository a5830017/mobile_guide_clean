//
//  MobileListModels.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

struct DisplayMobileList {
    //            let thumbImageURL : String
    //            let brand : String
    let price : String
    //            let description : String
    let name : String
    let rating : String
    var isFav : Bool
}

//struct FavouriteMobile {
//    let id : Int
//    let isFav : Bool
//}

struct MobileList {
    /// This structure represents a use case
    struct GetMobile {
        /// Data struct sent to Interactor
        struct Request {
            
        }
        /// Data struct sent to Presenter
        struct Response {
            let result: Result<[MobileModel], Error>
        }
        /// Data struct sent to ViewController
        struct ViewModel {
            let content: Result<[DisplayMobileList], Error>
            
            
        }
    }
    
    struct SortMobile {
        /// Data struct sent to Interactor
        struct Request {
            var sortType: SortType
        }
        /// DataypeTstruct sent to Presenter
        struct Response {
            let result: [MobileModel]
        }
        /// Data struct sent to ViewController
        struct ViewModel {
            let content: [DisplayMobileList]
        }
    }
    
    /// This structure represents a use case
    struct SwitchSegment {
        /// Data struct sent to Interactor
        struct Request {
            var segmentState: SegmentState
        }
        /// Data struct sent to Presenter
        struct Response {
            let result: [MobileModel]
        }
        /// Data struct sent to ViewController
        struct ViewModel {
            let content: [DisplayMobileList]
            
        }
    }
    
}
