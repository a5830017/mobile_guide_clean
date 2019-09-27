//
//  MobileListRouter.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListRouterInput {
    func navigateToSomewhere(sender: DisplayMobileList )
}

class MobileListRouter: MobileListRouterInput {
    weak var viewController: MobileListViewController!
    
    // MARK: - Navigation
    
    func navigateToSomewhere(sender: DisplayMobileList) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let selectedMobile = sender //as? MobileModel
        DetailViewController.interactor.mobile = selectedMobile
        viewController.navigationController?.pushViewController(DetailViewController, animated: true)
    }
    
    // MARK: - Communication
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        let showMobileDetail: String = "showMobileDetail"
        if segue.identifier == showMobileDetail {
            passDataToSomewhereScene(for: segue, sender: sender)
        }
    }
    
    func passDataToSomewhereScene(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
