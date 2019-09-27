//
//  DetailWorker.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol DetailStoreProtocol {
    func getImgList(url: String, _ completion: @escaping (Result<[ImageModel], Error>) -> Void)
}

class DetailWorker {

  var store: DetailStoreProtocol

  init(store: DetailStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func getImg(url: String, _ completion: @escaping (Result<[ImageModel], Error>) -> Void) {
    store.getImgList(url: url) { result in
        completion(result)
    }
  }
}
