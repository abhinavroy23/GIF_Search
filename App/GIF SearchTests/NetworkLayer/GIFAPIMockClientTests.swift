//
//  GIFAPIMockClientTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class GIFAPIMockClientTests: XCTestCase {
  var apiMockClient: GIFAPIInterface?
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    apiMockClient = GIFAPIMockClient()
  }
  
  func testTrendingMock() {
    apiMockClient?.fetchTrendingGifs(offset: 1, limit: 20, completion: { (result) in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    })
  }
  
  func testSearchMock() {
    apiMockClient?.searchGifs(searchQuery: "panda", offset: 1, limit: 20, completion: { (result) in
      switch result {
      case .success(let response):
        XCTAssertNotNil(response)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    })
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    apiMockClient = nil
  }
}
