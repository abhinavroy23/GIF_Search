//
//  HomeViewControllerTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search
import GIFInterfaces
import GIFNetwork

class HomeViewControllerTests: XCTestCase {
  var viewController: HomeViewController!
  
  override func setUpWithError() throws {
    viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: HomeViewController.self)) as? HomeViewController
    viewController.loadViewIfNeeded()
  }
  
  func testFetchTrending() {
    let expectation = self.expectation(description: "fetchTrending")
    viewController.fetchTrending(initialFetch: true) {
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)
    XCTAssertGreaterThanOrEqual(viewController.viewModel.trendingDataSource.gifs.count, 0)
  }
  
  func testFetchSearch() {
    let expectation = self.expectation(description: "fetchSearch")
    viewController.fetchSearchResults(initialFetch: true, forQuery: "panda") {
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)
    XCTAssertGreaterThanOrEqual(viewController.viewModel.searchDataSource.gifs.count, 0)
  }
  
  func testSearchActive() {
    viewController.searchBarTextDidBeginEditing(viewController.searchBar)
    XCTAssertTrue(viewController.viewModel.isSearchActive)
  }
  
  func testCancelButton() {
    viewController.cancelButton()
    XCTAssertFalse(viewController.viewModel.isSearchActive)
  }
  
  override func tearDownWithError() throws {
    self.viewController = nil
  }
  
}
