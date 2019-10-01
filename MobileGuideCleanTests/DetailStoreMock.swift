//
//  DetailStoreMock.swift
//  MobileGuideCleanTests
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright © 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

class DetailStoreMock : DetailStoreProtocol {
    func getImgList(url: String, _ completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        completion(.success([ImageListMock.Image.imageA, ImageListMock.Image.imageB, ImageListMock.Image.imageC]))
    }
}

