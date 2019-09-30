//
//  MobileListWorker.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import UIKit

protocol MobileListStoreProtocol {
  func getMobileList(url: String, _ completion: @escaping (Result<[MobileModel], Error>) -> Void)
}

class MobileListWorker {

  var store: MobileListStoreProtocol

  init(store: MobileListStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

    func getMobileList(url: String, _ completion: @escaping (Result<[MobileModel], Error>) -> Void) {
    store.getMobileList(url: url) { result in
        completion(result)
    }
  }
}
