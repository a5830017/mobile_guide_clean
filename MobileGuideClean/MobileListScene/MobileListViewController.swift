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
    func displayMobile(viewModel: MobileList.FeatureMobile.ViewModel)
    func displayRemoveMobile(viewModel: MobileList.FeatureMobile.ViewModel)
    
    var mobileList: [DisplayMobileList]? { get set }
    var favList: [DisplayMobileList]? { get set }
    var segmentState: SegmentState? { get set }
    var sortType: SortType? { get set }
}

class MobileListViewController: UIViewController, MobileListViewControllerInterface {
    
    var interactor: MobileListInteractorInterface!
    var router: MobileListRouter!
    
    @IBOutlet weak var tableViewMobileList : UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var tableViewCellId: String = "mobileTableViewCell"
    var tableViewshowDetail : String = "showMobileDetail"
    var mobileList: [DisplayMobileList]?
    var favList: [DisplayMobileList]?
    var segmentState: SegmentState?
    var sortType: SortType?
    var rmIndexPath: IndexPath?
    
    
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
        segmentState = .all
        doSomethingOnLoad()
        
    }
    
    // MARK: - Event handling
    
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        
        let request = MobileList.GetMobile.Request()
        interactor.doSomething(request: request)
    }
    
    // MARK: - Button Click
    @IBAction func didSortButtonTap(_ sender: Any) {
        let alertController = UIAlertController(title: "sort", message:
            "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Price low to high", style: .default, handler: { [weak self] action in
            let request = MobileList.FeatureMobile.Request(segmentState: self?.segmentState ?? .all, sortType: .priceLowToHigh)
            self?.interactor.check(request: request)
            
        }))
        alertController.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { [weak self] action in
            let request = MobileList.FeatureMobile.Request(segmentState: self?.segmentState ?? .all, sortType: .priceHighToLow)
            self?.interactor.check(request: request)
            
        }))
        alertController.addAction(UIAlertAction(title: "Rating", style: .default, handler: { [weak self] action in
            let request = MobileList.FeatureMobile.Request(segmentState: self?.segmentState ?? .all, sortType: .rating)
            self?.interactor.check(request: request)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Segment Control
    
    @IBAction func didSegmentControlChange(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0: // ALL
            print("ALL")
            segmentState = .all
            let request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: sortType ?? .isDefault)
            self.interactor.check(request: request)
            
            
        case 1: // Favourite
            segmentState = .favourite
            let request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: sortType ?? .isDefault)
            self.interactor.check(request: request)
            print("FAV")
            
        default:
            print("unknown")
        }
    }
    
    // MARK: - Display logic
    
    func displaySomething(viewModel: MobileList.GetMobile.ViewModel) {
        // NOTE: Display the result from the Presenter
        switch viewModel.content {
        case .success(let mobiles):
            mobileList = mobiles
            tableViewMobileList.reloadData()
            
        case .failure(let error):
            print(error)
            let alertController = UIAlertController(title: "Error", message: "Cannot Load Data", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "close", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func displayMobile(viewModel: MobileList.FeatureMobile.ViewModel) {
        mobileList = viewModel.content
        tableViewMobileList.reloadData()
    }
    
    func displayRemoveMobile(viewModel: MobileList.FeatureMobile.ViewModel) {
        mobileList = viewModel.content
    }
    
    
    
    // MARK: - Router
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue, sender: sender)
    }
    
    @IBAction func unwindToMobileListViewController(from segue: UIStoryboardSegue, sender: Any?) {
        print("unwind...")
        router.passDataToNextScene(segue: segue, sender: sender)
    }
}

extension MobileListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = mobileList?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? MobileListTableViewCell else {
            return UITableViewCell()
        }
        
        guard let mobile = mobileList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setupUI(mobile: mobile, segmentState: self.segmentState ?? .all)
        cell.delegate = self
        
        return cell
    }
}

extension MobileListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sender = mobileList?[indexPath.row] else { return }
        router.navigateToSomewhere(sender: sender)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (segmentState == .all) {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let rmId = mobileList?.remove(at: indexPath.row).id
//            guard let model = mobileList,
//                let index = model.firstIndex(where: { $0.id == favId}) else {
//                    return
//            }
//            let rm = mobileList?.remove(at: index)
            //mobileList?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let request = MobileList.rmId.Request(id: rmId ?? 0, isFav: false)
            self.interactor.removeFav(request: request)
            
        }
        
    }
}


extension MobileListViewController: MobileTableViewCellDelegate {
    func didFavouriteButtonTap(cell: MobileListTableViewCell) {
        guard let index = tableViewMobileList.indexPath(for: cell) else {
            return
        }
        let request = MobileList.FavId.Request(id: mobileList?[index.row].id ?? 0)
        self.interactor.setFav(request: request)
        
    }
    
}
