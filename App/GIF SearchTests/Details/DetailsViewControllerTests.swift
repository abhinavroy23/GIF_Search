//
//  DetailsViewControllerTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 26/01/21.
//

import XCTest
@testable import GIF_Search

class DetailsViewControllerTests: XCTestCase {
  var viewController: DetailsViewController!
  
  override func setUpWithError() throws {
    let gifService = GIFService(cachingService: GIFMockCachingService())
    let gifUIModel = GIFUIResult(withGifUrl: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    viewController = DetailsViewController.instance(gifService: gifService, gifUIModel: gifUIModel)
    viewController.loadViewIfNeeded()
  }
  
  func testGif() {
    XCTAssertNotNil(viewController.imageView.image)
  }
  
  func testCopyButton() {
    viewController.copyButton(UIButton())
    sleep(2)
    XCTAssertEqual(viewController.clipboardLabel.alpha, 0.0)
  }
  
  override func tearDownWithError() throws {
    self.viewController = nil
  }
}
