//
//  MobileListTableViewCell.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 24/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

import UIKit
//import Kingfisher

protocol MobileTableViewCellDelegate: class {
    func didFavouriteButtonTap(cell: MobileListTableViewCell)
}

class MobileListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mobileName: UILabel!
    @IBOutlet weak var mobileDescription: UILabel!
    @IBOutlet weak var mobilePrice: UILabel!
    @IBOutlet weak var mobileRating: UILabel!
    @IBOutlet weak var mobileImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: MobileTableViewCellDelegate?
    func setupUI(mobile : DisplayMobileList){
        mobileName.text = mobile.name
        mobileDescription.text = mobile.description
        mobilePrice.text = mobile.price
        mobileRating.text = mobile.rating
        mobileImageView.kf.setImage(with: URL(string: mobile.thumbImageURL))
//        favoriteButton.tag = index //tag btn click index
        favoriteButton.isSelected = mobile.isFav //swap button image
        
    }
    @IBAction func didFavouriteButtonTap(_ sender: Any) {
        delegate?.didFavouriteButtonTap(cell: self)
    }
}
