//
//  DetailInteractorTests.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

class DetailInteractorTests: XCTestCase {

    // MARK: - Subject under test

    var sut: DetailInteractor!



    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupDetailInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupDetailInteractor() {
        sut = DetailInteractor()
    }

    // MARK: - Test doubles

    final class DeatailPresenterSpy: DetailPresenterInterface {

        // MARK: Method call expectations
        var presentImgCalled = false

        // MARK: Spied methods
        func presentImg(response: Detail.Something.Response) {
            presentImgCalled = true
        }
    }

    final class DetailWorkerSpy: DetailWorker {
        // MARK: Method call expectations
        var getImgCalled = false
        var fetchDataFail = false
        var imgData: [ImageModel] = []

        // MARK: Spied methods
        override func getImg(url: String, _ completion: @escaping (Result<[ImageModel], Error>) -> Void) {
            getImgCalled = true

            if fetchDataFail {
                completion(.failure(ErrorStoreData.noInternetConnection))
            } else {
                store.getImgList(url: "url") { (result) in
                    switch result {
                    case .success(let data):
                        self.imgData = data
                        completion(result)
                    default:
                        return
                    }

                }
            }
        }
    }

    // MARK: - Tests

    func testGetImageDataShouldFail() {
        // Given
        let deatailPresenterSpy = DeatailPresenterSpy()
        sut.presenter = deatailPresenterSpy

        let detailWorkerSpy = DetailWorkerSpy(store: DetailStoreMock())
        detailWorkerSpy.fetchDataFail = true
        sut.worker = detailWorkerSpy

        let mobile: DisplayMobileList = DisplayMobileList(thumbImageURL: "url", brand: "brand", price: "price", description: "description", name: "name", rating: "1.1", isFav: false, id: 1)
        sut.mobile = mobile


        // When
        let request: Detail.Something.Request = Detail.Something.Request()
        sut.getImgData(request: request)

        // Then
        XCTAssertTrue(detailWorkerSpy.getImgCalled)
        XCTAssertTrue(deatailPresenterSpy.presentImgCalled)
    }

    func testGetImageDataShouldReturnData() {
        // Given
        let deatailPresenterSpy = DeatailPresenterSpy()
        sut.presenter = deatailPresenterSpy

        let detailWorkerSpy = DetailWorkerSpy(store: DetailStoreMock())
        detailWorkerSpy.fetchDataFail = false
        sut.worker = detailWorkerSpy

        let mobile: DisplayMobileList = DisplayMobileList(thumbImageURL: "url", brand: "brand", price: "price", description: "description", name: "name", rating: "1.1", isFav: false, id: 1)
        sut.mobile = mobile


        // When
        let request: Detail.Something.Request = Detail.Something.Request()
        sut.getImgData(request: request)

        // Then
        XCTAssertTrue(detailWorkerSpy.getImgCalled)
        XCTAssertTrue(deatailPresenterSpy.presentImgCalled)
        XCTAssertEqual(detailWorkerSpy.imgData.count, 3)
        XCTAssertEqual(detailWorkerSpy.imgData[0].id, 1)
        XCTAssertEqual(detailWorkerSpy.imgData[1].id, 2)

    }
    
    func testGetImageDataButMobileIsNull() {
        // Given
        let deatailPresenterSpy = DeatailPresenterSpy()
        sut.presenter = deatailPresenterSpy

        let detailWorkerSpy = DetailWorkerSpy(store: DetailStoreMock())
        detailWorkerSpy.fetchDataFail = false
        sut.worker = detailWorkerSpy

        let mobile: DisplayMobileList? = nil
        sut.mobile = mobile


        // When
        let request: Detail.Something.Request = Detail.Something.Request()
        sut.getImgData(request: request)

        // Then
        XCTAssertFalse(detailWorkerSpy.getImgCalled)
        XCTAssertFalse(deatailPresenterSpy.presentImgCalled)

    }

}
