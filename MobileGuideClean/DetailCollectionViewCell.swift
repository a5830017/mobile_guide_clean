//
//  DetailCollectionViewCell.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 26/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var mobileImageView: UIImageView!
    
//    func setupUI(mobile : MobileModel, img : ImageModel){
    func setupUI(img : DisplayMobileDetail){
//            detailDescription.text = mobile.description
//            detailRating.text = "Rating : " + String(mobile.rating)
//            detailPrice.text = "Price : $" + String(mobile.price)
    //        mobileImageView.kf.setImage(with: URL(string: img.url))
        detailDescription.text = "mobile id \(img.mobileId)"
//            let url = URL(string: img.url)
//            let image = UIImage(named: "placeholder_phone")
//            mobileImageView.kf.setImage(with: url, placeholder: image)
            
        }
    
}
