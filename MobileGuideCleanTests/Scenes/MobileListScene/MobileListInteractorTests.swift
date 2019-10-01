//
//  MobileListInteractorTests.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest
//import UIKit

class MobileListInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: MobileListInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMobileListInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMobileListInteractor() {
        sut = MobileListInteractor()
    }
    
    // MARK: - Test doubles
    
    final class MobileListPresenterSpy: MobileListPresenterInterface {
        
        // MARK: Method call expectations
        var presentDataFromApiCalled = false
        var presentFeatureCalled = false
        var presentRemoveCalled = false
        
        var mockModel: MobileList.GetMobile.Response!
        
        // MARK: Spied methods
        
        func presentDataFromApi(response: MobileList.GetMobile.Response) {
            presentDataFromApiCalled = true
            mockModel = response
        }
        
        func presentFeature(response: MobileList.FeatureMobile.Response) {
            presentFeatureCalled = true
        }
        
        func presentRemove(response: MobileList.FeatureMobile.Response) {
            presentRemoveCalled = true
        }
    }
    
    final class MobileListWorkerSpy: MobileListWorker {
        // MARK: Method call expectations
        var getMobileListCalled = false
        var fetchDataFail = false
        
        // MARK: Spied methods
        override func getMobileList(url: String, _ completion: @escaping (Result<[MobileModel], Error>) -> Void) {
            getMobileListCalled = true
            if fetchDataFail {
                completion(.failure(ErrorStoreData.noInternetConnection))
            } else {
                completion(.success([MobileListMock.Mobile.phoneA]))
            }
        }
    }


    
    // MARK: - Tests

    func testMobileListApiShouldReturnData() {
        // Given
        let mobileListPresenterSpy = MobileListPresenterSpy()
        sut.presenter = mobileListPresenterSpy


        let mobileListWorkerSpy = MobileListWorkerSpy(store: MobileListStoreMock())
        sut.worker = mobileListWorkerSpy

        // When
        let request: MobileList.GetMobile.Request = MobileList.GetMobile.Request()
        sut.getMobileListApi(request: request)

        // Then
        XCTAssertTrue(mobileListWorkerSpy.getMobileListCalled)
        XCTAssertTrue(mobileListPresenterSpy.presentDataFromApiCalled)

        switch  mobileListPresenterSpy.mockModel.result {
        case .success(let data):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(data[0].brand, "brand")
        default:
            XCTFail()
        }
    }

    func testMobileListApiShouldFail() {
        // Given
        let mobileListPresenterSpy = MobileListPresenterSpy()
        sut.presenter = mobileListPresenterSpy


        let mobileListWorkerSpy = MobileListWorkerSpy(store: MobileListStoreMock())
        mobileListWorkerSpy.fetchDataFail = true
        sut.worker = mobileListWorkerSpy

        // When
        let request: MobileList.GetMobile.Request = MobileList.GetMobile.Request()
        sut.getMobileListApi(request: request)

        // Then

        XCTAssertTrue(mobileListWorkerSpy.getMobileListCalled)
        XCTAssertTrue(mobileListPresenterSpy.presentDataFromApiCalled)

        switch  mobileListPresenterSpy.mockModel.result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (MobileGuideCleanTests.ErrorStoreData error 0.)")
        default:
            XCTFail()
        }
    }

    func testFilterFavouriteData() {
        //Given
        let mobileListPresenterSpy = MobileListPresenterSpy()
        sut.presenter = mobileListPresenterSpy
        sut.mobileList = [MobileListMock.Mobile.phoneA, MobileListMock.Mobile.phoneB]

        //When

        let request: MobileList.FavId.Request = MobileList.FavId.Request(id: 1)
        sut.setFav(request: request)

        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        //XCTAssertEqual(MobileSeeds.Mobile.phoneA.id, 1)
        XCTAssertNotNil(sut.favList)
        XCTAssertEqual(sut.favList.count, 1)
        XCTAssertEqual(sut.favList[0].id, 1)

    }

//    func testFilterFavouriteDataMobileListIsNull() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//
//        //When
//
//        let request: MobileList.FavId.Request = MobileList.FavId.Request(id: 1)
//        sut.setFav(request: request)
//
//        //Then
//        XCTAssertFalse(mobileListPresenterSpy.presentFeatureCalled)
//        //XCTAssertEqual(MobileSeeds.Mobile.phoneA.id, 1)
////        XCTAssertNotNil(sut.favList)
////        XCTAssertEqual(sut.favList![0].id, 1)
//
//    }
//
//    func testFilterFavouriteDataIsFavouriteIsNull() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        var phoneA = MobileListMock.Mobile.phoneA
//        phoneA.isFavourite = nil
//        sut.mobileList = [phoneA]
//
//        //When
//
//        let request: MobileList.FavId.Request = MobileList.FavId.Request(id: 1)
//        sut.setFav(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//        //XCTAssertEqual(MobileSeeds.Mobile.phoneA.id, 1)
//        XCTAssertNotNil(sut.favList)
//        XCTAssertEqual(sut.favList[0].id, 1)
//
//    }
//
    func testRemoveFavouriteDataFromFavouriteList() {
        //Given
        let mobileListPresenterSpy = MobileListPresenterSpy()
        sut.presenter = mobileListPresenterSpy
        sut.mobileList = [MobileListMock.Mobile.phoneA]

        //When
        let request : MobileList.rmId.Request = MobileList.rmId.Request(id: 1, isFav: false)
        sut.removeFav(request: request)

        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentRemoveCalled)
    }
//
//    func testRemoveFavouriteDataButDataToRemoveIsNull() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = [MobileListMock.Mobile.phoneC]
//
//        //When
//        let request : MobileList.rmId.Request = MobileList.rmId.Request(id: 1, isFav: false)
//        sut.removeFav(request: request)
//
//        //Then
//        XCTAssertFalse(mobileListPresenterSpy.presentRemoveCalled)
//
//    }
//
//
//
//
//    func testNoFavouriteAndUnsort() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .isDefault)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
//
//    func testNoFavouriteAndSortPriceLowToHigh() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//        sut.favList = MobileListMock.Mobile.favList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .priceLowToHigh)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
//
//    func testNoFavouriteAndSortPriceHighToLow() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//        sut.favList = MobileListMock.Mobile.favList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .priceHighToLow)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
//
//
//    func testNoFavouriteAndSortRating() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//        sut.favList = MobileListMock.Mobile.favList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .rating)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//
//    }
//
//    func testFavouriteAndUnsort() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .isDefault)
//        sut.check(request: request)
//
//        //Then
//        //XCTAssertTrue(MobileListInteractorSpy().filterFavCalled)
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
//
//    func testFavouriteAndSortPriceLowToHigh() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//        sut.favList = MobileListMock.Mobile.favList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .priceLowToHigh)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
//
//    func testFavouriteAndSortPriceHighToLow() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//        sut.favList = MobileListMock.Mobile.favList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .priceHighToLow)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
//
//    func testFavouriteAndSortRating() {
//        //Given
//        let mobileListPresenterSpy = MobileListPresenterSpy()
//        sut.presenter = mobileListPresenterSpy
//        sut.mobileList = MobileListMock.Mobile.mobileList
//        sut.favList = MobileListMock.Mobile.favList
//
//        //When
//        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .rating)
//        sut.check(request: request)
//
//        //Then
//        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
//
//    }
    
    
}
