//
//  DetailPresenterTests.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

class DetailPresenterTests: XCTestCase {

    // MARK: - Subject under test

    var sut: DetailPresenter!
    var detailViewControllerSpy: DetailViewControllerSpy!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupDetailPresenter()
        setupDetailViewControllerOutput()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Test setup

    func setupDetailPresenter() {
        sut = DetailPresenter()
    }
    
    func setupDetailViewControllerOutput(){
        detailViewControllerSpy = DetailViewControllerSpy()
        sut.viewController = detailViewControllerSpy
    }

    // MARK: - Test doubles

    final class DetailViewControllerSpy: DetailViewControllerInterface {
        // MARK: Method call expectations
        var displayImgFromApiCalled = false

        // MARK: Argument expectations
        var viewModel: Detail.Something.ViewModel!

        // MARK: Spied methods
        func displayImgFromApi(viewModel: Detail.Something.ViewModel) {
            displayImgFromApiCalled = true

            self.viewModel = viewModel
        }
    }

    // MARK: - Tests

    func testPresentFetchImageMobileDataFailShouldReturnFail() {
        // Given
        let phone: DisplayMobileList = DisplayMobileList(thumbImageURL: "url", brand: "brand", price: "price", description: "description", name: "name", rating: "rating", isFav: false, id: 1)

        let response = Detail.Something.Response(result: .failure(ErrorStoreData.noInternetConnection), mobile: phone)

        // When
        sut.presentImg(response: response)

        // Then
        let displayImgFromApi = detailViewControllerSpy.viewModel.content

        switch displayImgFromApi {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (MobileGuideCleanTests.ErrorStoreData error 0.)")
        default:
            XCTFail()
        }
    }

    func testPresentImageMobileDataFromApiShouldFormatDisplay() {
        // Given
        let imageA = ImageListMock.Image.imageA
        let imgs = [imageA]

        let phone: DisplayMobileList = DisplayMobileList(thumbImageURL: "url", brand: "brand", price: "price", description: "description", name: "name", rating: "rating", isFav: false, id: 1)

        let response = Detail.Something.Response(result: .success(imgs), mobile: phone)

        // When
        sut.presentImg(response: response)

        // Then
        let displayImgFromApi = detailViewControllerSpy.viewModel.content

        switch displayImgFromApi {
        case .success(let imgs):
            XCTAssertEqual(imgs.count, 1)
            XCTAssertEqual(imgs[0].id, 1)
            XCTAssertEqual(imgs[0].mobileId, 1)
            XCTAssertEqual(imgs[0].url, "url")
        default:
            XCTFail()
        }
    }

}
