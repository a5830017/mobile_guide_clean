//
//  DetailViewController.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailViewControllerInterface: class {
    func displayImgFromApi(viewModel: Detail.Something.ViewModel)
}

class DetailViewController: UIViewController, DetailViewControllerInterface {
    var interactor: DetailInteractorInterface!
    var router: DetailRouter!
    var imgList : [DisplayMobileDetail] = []
    let showDetail: String = "mobileCollectionViewCell"
    var mobileData: DisplayMobileList?
    
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
        getImgDataFromApiOnLoad()
    }
    
    // MARK: - Event handling
    
    func getImgDataFromApiOnLoad() {
        let request = Detail.Something.Request()
        interactor.getImgData(request: request)
    }
    
    // MARK: - Display logic
    
    func displayImgFromApi(viewModel: Detail.Something.ViewModel) {
        let mobile = viewModel.mobile
        self.mobileData = mobile
        switch viewModel.content {
        case .success(let imgs):
            imgList = imgs
            collectionView.reloadData()
            
        case .failure(let error):
            print(error)
            let alertController = UIAlertController(title: "Error", message: "Cannot Load Data", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "close", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
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

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getImgDataFromApiOnLoad()
        return imgList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: showDetail, for: indexPath) as? DetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imgModel : DisplayMobileDetail = imgList[indexPath.row]
        guard let mobile = self.mobileData else { return UICollectionViewCell() }
        cell.setupUI(img: imgModel, mobile: mobile)
        self.navigationItem.title = "\(mobile.name)"
        return cell
    }
}
