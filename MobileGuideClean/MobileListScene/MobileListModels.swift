//
//  MobileListModels.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

struct DisplayMobileList {
    let thumbImageURL : String
    let brand : String
    let price : String
    let description : String
    let name : String
    let rating : String
    var isFav : Bool
    let id : Int
}

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
    
    struct FeatureMobile {
        /// Data struct sent to Interactor
            struct Request {
                var segmentState: SegmentState
                var sortType: SortType
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
    
    struct FavId {
        /// Data struct sent to Interactor
        struct Request {
            var id: Int
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
