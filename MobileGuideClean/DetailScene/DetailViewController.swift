//
//  DetailViewController.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailViewControllerInterface: class {
    func displaySomething(viewModel: Detail.Something.ViewModel)
}

class DetailViewController: UIViewController, DetailViewControllerInterface {
    var interactor: DetailInteractorInterface!
    var router: DetailRouter!
    var imgList : [DisplayMobileDetail] = []
    let showDetail: String = "showDetail"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(viewController: self)
    }
    
    // MARK: - Configuration
    
    private func configure(viewController: DetailViewController) {
        let router = DetailRouter()
        router.viewController = viewController
        
        let presenter = DetailPresenter()
        presenter.viewController = viewController
        
        let interactor = DetailInteractor()
        interactor.presenter = presenter
        interactor.worker = DetailWorker(store: DetailStore())
        
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
        
        let request = Detail.Something.Request()
        interactor.doSomething(request: request)
    }
    
    // MARK: - Display logic
    
    func displaySomething(viewModel: Detail.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        
        switch viewModel.content {
        case .success(let imgs):
            imgList = imgs
            collectionView.reloadData()
            
        case .failure(let error):
            print(error)
        }
    }
    
    // MARK: - Router
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
    
    @IBAction func unwindToDetailViewController(from segue: UIStoryboardSegue) {
        print("unwind...")
        router.passDataToNextScene(segue: segue)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: showDetail, for: indexPath) as? DetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        //            let mobileModel: MobileModel = mobile
        let imgModel : DisplayMobileDetail = imgList[indexPath.row]
        //            cell.setupUI(mobile: mobileModel, img: imgModel)
        cell.setupUI(img: imgModel)
        return cell
    }
    
    
    
}

