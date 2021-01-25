//
//  FavouriteViewControllerTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class FavouriteViewControllerTests: XCTestCase {
  var viewController: FavouritesViewController!
  
  override func setUpWithError() throws {
    viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: FavouritesViewController.self)) as? FavouritesViewController
    viewController.loadViewIfNeeded()
    viewController.viewWillAppear(false)
  }
  
  func testFetchFavourites() {
    let expectation = self.expectation(description: "fetchFavourites")
    viewController.fetchFavourites {
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertGreaterThanOrEqual(viewController.viewModel.dataSource.gifs.count, 0)
  }
  
  override func tearDownWithError() throws {
    self.viewController = nil
  }
}
