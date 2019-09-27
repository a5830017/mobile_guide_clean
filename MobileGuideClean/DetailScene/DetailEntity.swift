//
//  DetailEntity.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import Foundation

struct ImageModel : Codable {
    let url : String
    let mobileId : Int
    let id : Int
    
    private enum CodingKeys: String, CodingKey {
        case url
        case mobileId = "mobile_id"
        case id
    }
}
