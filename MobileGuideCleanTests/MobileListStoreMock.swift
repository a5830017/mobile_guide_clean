//
//  MobileListStoreMock.swift
//  MobileGuideCleanTests
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

class MobileListStoreMock : MobileListStoreProtocol {
    func getMobileList(url: String, _ completion: @escaping (Result<[MobileModel], Error>) -> Void) {
        completion(.success([MobileListMock.Mobile.phoneA]))
    }
}
