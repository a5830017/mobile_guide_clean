//
//  MobileListPresenterTests.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

class MobileListPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: MobileListPresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMobileListPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMobileListPresenter() {
        sut = MobileListPresenter()
    }
    
    // MARK: - Test doubles
    
    final class MobileListViewControllerSpy: MobileListViewControllerInterface {
        
        // MARK: Method call expectations
        var displayMobileApiCalled = false
        var displayMobileCalled = false
        var displayRemoveMobile = false
        
        // MARK: Argument expectations
        
        var viewModelApi: MobileList.GetMobile.ViewModel!
        var viewModelFeature: MobileList.FeatureMobile.ViewModel!
        
        
        // MARK: Spied methods
        func displayMobileApi(viewModel: MobileList.GetMobile.ViewModel) {
            displayMobileApiCalled = true
            self.viewModelApi = viewModel
        }
        
        func displayMobile(viewModel: MobileList.FeatureMobile.ViewModel) {
            displayMobileCalled = true
            self.viewModelFeature = viewModel
        }
        
        func displayRemoveMobile(viewModel: MobileList.FeatureMobile.ViewModel) {
            displayRemoveMobile = true
            self.viewModelFeature = viewModel
        }
        
        var mobileList: [DisplayMobileList]?
        
        var favList: [DisplayMobileList]?
        
        var segmentState: SegmentState?
        
        var sortType: SortType?
        
        
    }
    
    // MARK: - Tests
    
    func testPresentFetchMobileDataFromApiShouldFormatForDisplay() {
        // Given
        let mobileListViewControllerSpy = MobileListViewControllerSpy()
        sut.viewController = mobileListViewControllerSpy
        
        // When
        let phoneA = MobileListMock.Mobile.phoneA
        let mobiles = [phoneA]
        
        let response = MobileList.GetMobile.Response(result: .success(mobiles))
        sut.presentDataFromApi(response: response)
        
        // Then
        let displayMobileDataApi = mobileListViewControllerSpy.viewModelApi.content
        
        switch displayMobileDataApi {
        case .success(let mobiles):
            XCTAssertEqual(mobiles.count, 1)
            XCTAssertEqual(mobiles[0].name, "name")
            XCTAssertEqual(mobiles[0].price, "price : $1.1")
            XCTAssertEqual(mobiles[0].thumbImageURL, "url")
            XCTAssertEqual(mobiles[0].brand, "brand")
            XCTAssertEqual(mobiles[0].rating, "rating : 1.2")
            XCTAssertEqual(mobiles[0].id, 1)
            XCTAssertEqual(mobiles[0].description, "description")
            XCTAssertEqual(mobiles[0].isFav, false)
        default:
            XCTFail()
        }
    }
    
    func testPresentFetchMobileFailFromApiShouldReturnError() {
        // Given
        let mobileListViewControllerSpy = MobileListViewControllerSpy()
        sut.viewController = mobileListViewControllerSpy
        
        // When
        let response = MobileList.GetMobile.Response(result: .failure(ErrorStoreData.noInternetConnection))
        sut.presentDataFromApi(response: response)
        
        // Then
        let displayMobileDataApi = mobileListViewControllerSpy.viewModelApi.content
        
        switch displayMobileDataApi {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (MobileGuideCleanTests.ErrorStoreData error 0.)")
            
        default:
            XCTFail()
        }
    }
    
    func testPresentFetchMobileDataFromApiShouldAskViewControllerToDisplayMobileApi()
    {
        // Given
        let mobileListViewControllerSpy = MobileListViewControllerSpy()
        sut.viewController = mobileListViewControllerSpy
        
        // When
        let phoneA = MobileListMock.Mobile.phoneA
        let mobiles = [phoneA]
        
        let response = MobileList.GetMobile.Response(result: .success(mobiles))
        sut.presentDataFromApi(response: response)
        
        // Then
        XCTAssert(mobileListViewControllerSpy.displayMobileApiCalled)
    }
//    
//    func testPresentFavouriteAndSortShouldFormatForDisplay() {
//        // Given
//        let mobileListViewControllerSpy = MobileListViewControllerSpy()
//        sut.viewController = mobileListViewControllerSpy
//        // when
//        let phoneA = MobileListMock.Mobile.phoneA
//        let mobiles = [phoneA]
//        
//        let response = MobileList.FeatureMobile.Response(result: mobiles)
//        sut.presentFeature(response: response)
//        
//        //Then
//        let displayMobileData = mobileListViewControllerSpy.viewModelFeature.content
//        
//        XCTAssertEqual(displayMobileData.count, 1)
//        XCTAssertEqual(displayMobileData[0].id, 1)
//        
//        
//    }
//    
//    func testPresentFavouriteAndSortShouldAskViewControllerToDisplayMobileFeture() {
//        // Given
//        let mobileListViewControllerSpy = MobileListViewControllerSpy()
//        sut.viewController = mobileListViewControllerSpy
//        // when
//        let phoneA = MobileListMock.Mobile.phoneA
//        let mobiles = [phoneA]
//        
//        let response = MobileList.FeatureMobile.Response(result: mobiles)
//        sut.presentFeature(response: response)
//        
//        //Then
//        XCTAssert(mobileListViewControllerSpy.displayMobileCalled)
//        
//        
//    }
//    
//    func testPresentRemoveFavouriteMobileShouldFormatForDisplay() {
//        // Given
//        let mobileListViewControllerSpy = MobileListViewControllerSpy()
//        sut.viewController = mobileListViewControllerSpy
//        // when
//        let phoneA = MobileListMock.Mobile.phoneA
//        let mobiles = [phoneA]
//        
//        let response = MobileList.FeatureMobile.Response(result: mobiles)
//        sut.presentRemove(response: response)
//        
//        //Then
//        let displayMobileDataAfterRemove = mobileListViewControllerSpy.viewModelFeature.content
//        
//        XCTAssertEqual(displayMobileDataAfterRemove.count, 1)
//    }
//    
//    func testPresentFavouriteAndSortShouldAskViewControllerToDisplayAfterRemoveMobile() {
//        // Given
//        let mobileListViewControllerSpy = MobileListViewControllerSpy()
//        sut.viewController = mobileListViewControllerSpy
//        // when
//        let phoneA = MobileListMock.Mobile.phoneA
//        let mobiles = [phoneA]
//        
//        let response = MobileList.FeatureMobile.Response(result: mobiles)
//        sut.presentRemove(response: response)
//        
//        //Then
//        XCTAssert(mobileListViewControllerSpy.displayRemoveMobile)
//    }
//}
