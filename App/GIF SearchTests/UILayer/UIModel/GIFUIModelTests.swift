//
//  GIFUIModelTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
import GIFInterfaces
@testable import GIF_Search

class GIFUIModelTests: XCTestCase {
  var mockApiService: GIFAPIInterface?
  
  override func setUpWithError() throws {
    self.mockApiService = GIFAPIMockClient()
  }
  
  func testInit() {
    let model = GIFUIModel()
    XCTAssertNotNil(model)
  }
  
  func testInitWithDataModel() {
    mockApiService?.fetchTrendingGifs(offset: 1, limit: 20, completion: { (result) in
      switch result {
      case .success(let response):
        let model: GIFUIModel = GIFUIModel(gifDataModel: response)
        XCTAssertNotNil(model)
        XCTAssertGreaterThanOrEqual(model.gifs.count, 0)
        XCTAssertEqual(model.offset, 1)
        XCTAssertEqual(model.limit, 20)
      case .failure(let error):
      XCTFail(error.localizedDescription)
      }
    })
  }
  
  func testInitWithUrls() {
    let urls: [String] = ["https://media.giphy.com/media/KyBX9ektgXWve/source.gif"]
    let model: GIFUIModel = GIFUIModel(withGifUrls: urls)
    XCTAssertNotNil(model)
    XCTAssertGreaterThanOrEqual(model.gifs.count, 0)
    XCTAssertEqual(model.offset, 1)
    XCTAssertEqual(model.limit, 20)
  }
  
  func testUpdateModel() {
    mockApiService?.fetchTrendingGifs(offset: 1, limit: 20, completion: { (result) in
      switch result {
      case .success(let response):
        var model: GIFUIModel = GIFUIModel()
        model.updateModel(withDataModel: response)
        XCTAssertNotNil(model)
        XCTAssertGreaterThanOrEqual(model.gifs.count, 0)
        XCTAssertEqual(model.offset, 1)
        XCTAssertEqual(model.limit, 20)
      case .failure(let error):
      XCTFail(error.localizedDescription)
      }
    })
  }
  
  func testFlush() {
    let urls: [String] = ["https://media.giphy.com/media/KyBX9ektgXWve/source.gif"]
    var model: GIFUIModel = GIFUIModel(withGifUrls: urls)
    model.flush()
    XCTAssertEqual(model.gifs.count, 0)
  }
  
  func testUIresultWithData() {
    mockApiService?.fetchTrendingGifs(offset: 1, limit: 20, completion: { (result) in
      switch result {
      case .success(let response):
        let model: GIFUIResult? = GIFUIResult(gifData: response.data[0])
        XCTAssertNotNil(model?.url)
        XCTAssertNotNil(model?.name)
      case .failure(let error):
      XCTFail(error.localizedDescription)
      }
    })
  }
  
  func testUIResultWithUrl() {
    let model: GIFUIResult? = GIFUIResult(withGifUrl: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")
    XCTAssertNotNil(model?.url)
  }
  
  func testFailableIntiailizer() {
    let model: GIFUIResult? = GIFUIResult(withGifUrl: "")
    XCTAssertNil(model)
  }
  
  override func tearDownWithError() throws {
    self.mockApiService = nil
  }
}
