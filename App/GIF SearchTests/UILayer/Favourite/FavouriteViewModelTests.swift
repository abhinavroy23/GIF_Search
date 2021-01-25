//
//  FavouriteViewModelTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class FavouriteViewModelTests: XCTestCase {
  var viewModel: FavouritesViewModel?
  
  override func setUpWithError() throws {
    let mockCachingService = GIFMockCachingService()
    let mockFavouriteService = GIFFavouritesService(cachingService: mockCachingService)
    viewModel = FavouritesViewModel(favouriteService: mockFavouriteService)
  }
  
  func testFetchFavourites() {
    viewModel?.fetchFavourites {
      XCTAssertNotNil(viewModel?.dataSource)
    }
  }
  
  func testDataSource() {
    XCTAssertEqual(viewModel?.getDataSource().gifs.count, viewModel?.dataSource.gifs.count)
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
  }
  
}
