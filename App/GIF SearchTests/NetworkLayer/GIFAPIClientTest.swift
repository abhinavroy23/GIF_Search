//
//  GIFAPIClientTest.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

private let GIFApiKey_Encoded: String = "ZHRUbDR5eFVYa3F1OG9OdEJVd2V2WUtjdGRnYW5mdjU="

class GIFAPIClientTest: XCTestCase {
  
  func testTrendingGifRequest() {
    let trending = GIFAPIRequest.trendingGifs(offset: 1, limit: 20)
    XCTAssertEqual(trending.url, URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=\(GIFApiKey_Encoded.base64Decoded())&offset=1&limit=20"))
    XCTAssertNil(trending.header)
    XCTAssertNil(trending.body)
  }
  
  func testSearchGifRequest() {
    let search = GIFAPIRequest.searchGifs(searchQuery: "panda", offset: 1, limit: 20)
    XCTAssertEqual(search.url, URL(string: "https://api.giphy.com/v1/gifs/search?api_key=\(GIFApiKey_Encoded.base64Decoded())&q=panda&offset=1&limit=20"))
    XCTAssertNil(search.header)
    XCTAssertNil(search.body)
  }
  
  func testGIFClientError() {
    let error = GIFClientError.unableToFetchData
    XCTAssertEqual(error.description, "Unable to fetch data. Pelase try again!")
  }
}
