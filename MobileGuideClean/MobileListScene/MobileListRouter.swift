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
        // NOTE: Teach the router how to navigate to another scene. Some examples follow:
        
        // 1. Trigger a storyboard segue
        //    viewController.performSegue(withIdentifier: "showDetail", sender: sender)
        
        //passDataToNextScene(segue: , sender: sender)
        
        // 2. Present another view controller programmatically
        // viewController.presentViewController(someWhereViewController, animated: true, completion: nil)
        
        // 3. Ask the navigation controller to push another view controller onto the stack
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
        
        // 4. Present a view controller from a different storyboard
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let selectedMobile = sender //as? MobileModel
        DetailViewController.interactor.mobile = selectedMobile
        viewController.navigationController?.pushViewController(DetailViewController, animated: true)
    }
    
    // MARK: - Communication
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        let showMobileDetail: String = "showMobileDetail"
        // NOTE: Teach the router which scenes it can communicate with
        
        //    if segue.identifier == "showMobileDetail",
        //        let viewController = segue.destination as? DetailViewController,
        //        let selectedMobile = sender as? MobileModel {
        //        viewController.mobile = selectedMobile
        
        if segue.identifier == showMobileDetail {
            passDataToSomewhereScene(for: segue, sender: sender)
        }
    }
    
    func passDataToSomewhereScene(for segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router how to pass data to the next scene
        //    let viewController = segue.destination as? DetailViewController,
        //        let selectedMobile = sender as? MobileModel {
        //        viewController.mobile = selectedMobile
        //    }
        //
//        let DetailViewController = segue.destination as? DetailViewController
//        let selectedMobile = sender as? MobileModel
//        DetailViewController!.interactor.mobile = selectedMobile//viewController.interactor.model
        
    }
}
