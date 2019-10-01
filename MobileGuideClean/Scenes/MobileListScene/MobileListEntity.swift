//
//  MobileListEntity.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import Foundation

struct MobileModel : Codable {
    let thumbImageURL : String
    let brand : String
    let price : Float
    let description : String
    let name : String
    let rating : Float
    let id : Int
    var isFavourite : Bool?
}
