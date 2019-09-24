//
//  MobileListViewController.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListViewControllerInterface: class {
    func displaySomething(viewModel: MobileList.GetMobile.ViewModel)
}

class MobileListViewController: UIViewController, MobileListViewControllerInterface {
    
    var interactor: MobileListInteractorInterface!
    var router: MobileListRouter!
    
    @IBOutlet weak var tableViewMobileList : UITableView!
    
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(viewController: self)
    }
    
    // MARK: - Configuration
    
    private func configure(viewController: MobileListViewController) {
        let router = MobileListRouter()
        router.viewController = viewController
        
        let presenter = MobileListPresenter()
        presenter.viewController = viewController
        
        let interactor = MobileListInteractor()
        interactor.presenter = presenter
        interactor.worker = MobileListWorker(store: MobileListStore())
        
        viewController.interactor = interactor
        viewController.router = router
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomethingOnLoad()
    }
    
    // MARK: - Event handling
    
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        
        let request = MobileList.GetMobile.Request()
        interactor.doSomething(request: request)
    }
    
    // MARK: - Display logic
    
    var mobileList:[MobileList.GetMobile.ViewModel.DisplayMobileList] = []
    
    func displaySomething(viewModel: MobileList.GetMobile.ViewModel) {
        // NOTE: Display the result from the Presenter
        switch viewModel.content {
        case .success(let mobiles):
            mobileList = mobiles
            tableViewMobileList.reloadData()
            
        case .failure(let error):
            break
        }
    }
    
    // MARK: - Router
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
    
    @IBAction func unwindToMobileListViewController(from segue: UIStoryboardSegue) {
        print("unwind...")
        router.passDataToNextScene(segue: segue)
    }
}

extension MobileListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mobileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mobileTableViewCell", for: indexPath) as? MobileListTableViewCell else {
            return UITableViewCell()
        }
        let mobile: MobileList.GetMobile.ViewModel.DisplayMobileList = mobileList[indexPath.row]
        cell.setupUI(mobile: mobile)
        //            cell.delegate = self
        
        return cell
    }
}

extension MobileListViewController: UITableViewDelegate {
    
}
