//
//  MobileListTableViewCell.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 24/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

import UIKit
//import Kingfisher

//protocol MobileTableViewCellDelegate: class {
//    func didFavouriteButtonTap(cell: MobileListTableViewCell)
//}

class MobileListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mobileName: UILabel!
    @IBOutlet weak var mobileDescription: UILabel!
    @IBOutlet weak var mobilePrice: UILabel!
    @IBOutlet weak var mobileRating: UILabel!
    @IBOutlet weak var mobileImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
//    var delegate: MobileTableViewCellDelegate?
    func setupUI(mobile : MobileList.GetMobile.ViewModel.DisplayMobileList){
        mobileName.text = mobile.name
//        mobileDescription.text = mobile.description
        mobilePrice.text = "Price : $" + String(mobile.price)
        mobileRating.text = "Rating : " + String(mobile.rating)
//        mobileImageView.kf.setImage(with: URL(string: mobile.thumbImageURL))
//        favoriteButton.tag = index //tag btn click index
//        favoriteButton.isSelected = mobile.isFavourite ?? false //swap button image
        
    }
    
//    @IBAction func favoriteButton(_ sender: UIButton) {
//        delegate?.didFavouriteButton(cell: self)
//    }
}
