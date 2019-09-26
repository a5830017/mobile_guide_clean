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
    
    // MARK: - Button Click
    @IBAction func didSortButtonTap(_ sender: Any) {
//        var request = MobileList.FeatureMobile.Request(segmentState: segmentState, sortType: sortType)
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
//            tableViewMobileList.reloadData()
            
            
        case 1: // Favourite
            segmentState = .favourite
            let request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: sortType ?? .isDefault)
            self.interactor.check(request: request)
//            tableViewMobileList.reloadData()
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
        }
    }
    
//    var sortedList: [MobileList.SortMobile.ViewModel.DisplayMobileList] = []
    
    func displayMobile(viewModel: MobileList.FeatureMobile.ViewModel) {
        mobileList = viewModel.content
        tableViewMobileList.reloadData()
    }
    
//    func displayFavouriteMobile(viewModel: MobileList.SwitchSegment.ViewModel) {
//        favList = viewModel.content
//        tableViewMobileList.reloadData()
//    }
        
    
    // MARK: - Router
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        router.passDataToNextScene(segue: segue)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue, sender: sender)
//    if segue.identifier == "showMobileDetail",
//        let viewController = segue.destination as? DetailViewController,
//        let selectedMobile = sender as? MobileModel {
//        viewController.mobile = selectedMobile
    }
    
    @IBAction func unwindToMobileListViewController(from segue: UIStoryboardSegue, sender: Any?) {
        print("unwind...")
        router.passDataToNextScene(segue: segue, sender: sender)
    }
}

extension MobileListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(segmentControl.selectedSegmentIndex == 0) {
//            return mobileList?.count ?? 0
//        }
//        } else {
//            return favList?.count ?? 0
//        }
//        return mobileList?.count ?? []
        return mobileList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? MobileListTableViewCell else {
            return UITableViewCell()
        }
        
        
        //if let mobile = mobileList?[indexPath.row] {
        guard let mobile = mobileList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setupUI(mobile: mobile)
        cell.delegate = self
        
        return cell
    }
}

extension MobileListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(segmentControl.selectedSegmentIndex == 0){
            guard let sender = mobileList?[indexPath.row] else {
                return
            }
            router.navigateToSomewhere(sender: sender)
//            performSegue(withIdentifier: tableViewshowDetail, sender: sender)
        } else {
            guard let sender = favList?[indexPath.row] else {
                return
            }
            router.navigateToSomewhere(sender: sender)
//            performSegue(withIdentifier: tableViewshowDetail, sender: sender)
        }
    }
}

extension MobileListViewController: MobileTableViewCellDelegate {
    func didFavouriteButtonTap(cell: MobileListTableViewCell) {
        guard let index = tableViewMobileList.indexPath(for: cell) else {
            return
        }
//        mobileList[index.row].isFav = !mobileList[index.row].isFav
        let request = MobileList.FavId.Request(id: mobileList?[index.row].id ?? 0)
        self.interactor.setFav(request: request)
        
    }
    
}
