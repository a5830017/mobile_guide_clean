//
//  Seeds.swift
//  MobileGuideCleanTests
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

struct MobileListMock {
    
    struct Mobile {
        
        static var phoneA: MobileModel = MobileModel(thumbImageURL: "url", brand: "brand", price: 1.1, description: "description", name: "name", rating: 1.2, id: 1, isFavourite: false)
        
        static var phoneB: MobileModel = MobileModel(thumbImageURL: "url", brand: "brand", price: 1.1, description: "description", name: "name", rating: 1.2, id: 2, isFavourite: false)
        
        static var phoneC: MobileModel = MobileModel(thumbImageURL: "url", brand: "brand", price: 1.1, description: "description", name: "name", rating: 1.2, id: 3, isFavourite: true)
        
        static var phoneD: MobileModel = MobileModel(thumbImageURL: "url", brand: "brand", price: 1.1, description: "description", name: "name", rating: 1.2, id: 4, isFavourite: true)
        
        static let mobileList: [MobileModel] = [phoneA, phoneB, phoneC]
        
        static let favList: [MobileModel] = [phoneC, phoneD]
        
    }
}

enum ErrorStoreData: Error {
    case noInternetConnection
}

struct ImageListMock {
    
    struct Image {
        
        static var imageA: ImageModel = ImageModel(url: "url", mobileId: 1, id: 1)
        static var imageB: ImageModel = ImageModel(url: "url", mobileId: 1, id: 2)
        static var imageC: ImageModel = ImageModel(url: "url", mobileId: 1, id: 3)
    }
}
