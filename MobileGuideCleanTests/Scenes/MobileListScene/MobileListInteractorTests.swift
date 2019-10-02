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
    var mobileListPresenterSpy: MobileListPresenterSpy!
    var mobileListWorkerSpy: MobileListWorkerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMobileListInteractor()
        setupMobileListPresenterOutput()
        setupWorker()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMobileListInteractor() {
        sut = MobileListInteractor()
    }
    
    func setupMobileListPresenterOutput() {
        mobileListPresenterSpy = MobileListPresenterSpy()
        sut.presenter = mobileListPresenterSpy
    }
    
    func setupWorker() {
        mobileListWorkerSpy = MobileListWorkerSpy(store: MobileListStoreMock())
        sut.worker = mobileListWorkerSpy
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
        let request: MobileList.GetMobile.Request = MobileList.GetMobile.Request()
        
        // When
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
        mobileListWorkerSpy.fetchDataFail = true
        let request: MobileList.GetMobile.Request = MobileList.GetMobile.Request()
        
        // When
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
        sut.mobileList = [MobileListMock.Mobile.phoneA, MobileListMock.Mobile.phoneB]
        let request: MobileList.FavId.Request = MobileList.FavId.Request(id: 1)
        
        //When
        sut.setFav(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        XCTAssertNotNil(sut.favList)
        XCTAssertEqual(sut.favList.count, 1)
        XCTAssertEqual(sut.favList[0].id, 1)
        
    }
    
    func testFilterFavouriteDataMobileListIsNull() {
        //Given
        let request: MobileList.FavId.Request = MobileList.FavId.Request(id: 1)
        
        //When
        sut.setFav(request: request)
        
        //Then
        XCTAssertFalse(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testFilterFavouriteDataIsFavouriteIsNull() {
        //Given
        var phoneA = MobileListMock.Mobile.phoneA
        phoneA.isFavourite = nil
        sut.mobileList = [phoneA]
        let request: MobileList.FavId.Request = MobileList.FavId.Request(id: 1)
        
        //When
        sut.setFav(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        XCTAssertNotNil(sut.favList)
        XCTAssertEqual(sut.favList[0].id, 1)
        
    }
    
    func testRemoveFavouriteDataFromFavouriteList() {
        //Given
        sut.mobileList = [MobileListMock.Mobile.phoneA]
        let request : MobileList.rmId.Request = MobileList.rmId.Request(id: 1, isFav: false)
        
        //When
        sut.removeFav(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentRemoveCalled)
    }
    
    func testRemoveFavouriteDataButDataToRemoveIsNull() {
        //Given
        sut.mobileList = [MobileListMock.Mobile.phoneC]
        let request : MobileList.rmId.Request = MobileList.rmId.Request(id: 1, isFav: false)
        
        //When
        sut.removeFav(request: request)
        
        //Then
        XCTAssertFalse(mobileListPresenterSpy.presentRemoveCalled)
        
    }
    
    
    
    
    func testNoFavouriteAndUnsort() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .isDefault)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testNoFavouriteAndSortPriceLowToHigh() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .priceLowToHigh)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testNoFavouriteAndSortPriceHighToLow() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .priceHighToLow)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    
    func testNoFavouriteAndSortRating() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .rating)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
        
    }
    
    func testFavouriteAndUnsort() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .isDefault)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testFavouriteAndSortPriceLowToHigh() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .priceLowToHigh)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testFavouriteAndSortPriceHighToLow() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .priceHighToLow)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testFavouriteAndSortRating() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .rating)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testFavouriteAndSortTypeIsUnsort() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .favourite, sortType: .isDefault)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
    
    func testAllListAndSortTypeIsUnsort() {
        //Given
        sut.mobileList = MobileListMock.Mobile.mobileList
        sut.favList = MobileListMock.Mobile.favList
        let request : MobileList.FeatureMobile.Request = MobileList.FeatureMobile.Request(segmentState: .all, sortType: .isDefault)
        
        //When
        sut.check(request: request)
        
        //Then
        XCTAssertTrue(mobileListPresenterSpy.presentFeatureCalled)
        
    }
}
