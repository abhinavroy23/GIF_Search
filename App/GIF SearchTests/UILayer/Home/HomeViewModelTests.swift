//
//  HomeViewModelTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class HomeViewModelTests: XCTestCase {
  var viewModel: HomeViewModel?
  
  override func setUpWithError() throws {
    let apiMockServive: GIFAPIInterface = GIFAPIMockClient()
    viewModel = HomeViewModel(apiService: apiMockServive)
  }
  
  func testGetDataSource() {
    viewModel?.isSearchActive = true
    XCTAssertEqual(viewModel?.getDataSource().gifs.count, viewModel?.searchDataSource.gifs.count)
    viewModel?.isSearchActive = false
    XCTAssertEqual(viewModel?.getDataSource().gifs.count, viewModel?.trendingDataSource.gifs.count)
  }
  
  func testFetchTrending() {
    viewModel?.fetchTrending(initialFetch: true, withCompletion: { (success, error) in
      XCTAssertEqual(success, true)
    })
  }
  
  func testSearch() {
    viewModel?.fetchSearchResults(initialFetch: true, forQuery: "panda", withCompletion: { (success, error) in
      XCTAssertEqual(success, true)
    })
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
  }
  
}
