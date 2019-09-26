//
//  DetailCollectionViewCell.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 26/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

import UIKit
import Kingfisher

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var mobileImageView: UIImageView!
    
    func setupUI(img : DisplayMobileDetail, mobile: DisplayMobileList){
        detailRating.text = "Rating : \(mobile.rating)"
        detailPrice.text = "Price : $\(mobile.price)"
        detailDescription.text = "\(mobile.description)"
        let url = URL(string: img.url)
        let image = UIImage(named: "placeholder_phone")
        mobileImageView.kf.setImage(with: url, placeholder: image)
        
    }
    
}
