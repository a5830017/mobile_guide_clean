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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.thumbImageURL = try container.decodeIfPresent(String.self, forKey: .thumbImageURL)!
        self.brand = try container.decodeIfPresent(String.self, forKey: .brand)!
        self.price = try container.decodeIfPresent(Float.self, forKey: .price)!
        self.description = try container.decodeIfPresent(String.self, forKey: .description)!
        self.name = try container.decodeIfPresent(String.self, forKey: .name)!
        self.rating = try container.decodeIfPresent(Float.self, forKey: .rating)!
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)!
        self.isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
    }
}
