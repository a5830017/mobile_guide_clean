//
//  MobileListInteractorTests.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 30/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

@testable import MobileGuideClean
import XCTest

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

  // MARK: - Tests

  func testSomething() {
    // Given

    // When

    // Then
  }
}
