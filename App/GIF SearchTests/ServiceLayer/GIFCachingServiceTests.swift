//
//  GIFCachingServiceTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
import GIFInterfaces
@testable import GIF_Search
import SDWebImage

class GIFCachingServiceTests: XCTestCase {
  var cachingService: GIFCachingInterface?
  var cachingService2: GIFCachingInterface?
  
  override func setUpWithError() throws {
    cachingService = GIFMockCachingService()
    cachingService2 = GIFCachingService()
  }
  
  func testStoreAndGet() {
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "test")!
    cachingService?.store(image: image, forUrl: url)
    cachingService?.getCachedImage(forUrl: url, withCompletion: { (myImage) in
      XCTAssertEqual(myImage, image)
    })
  }
  
  func testStoreAndGetFromDisk() {
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "test")!
    cachingService?.store(image: image, forUrl: url)
    cachingService?.getCachedImageFromDisk(forUrl: url, withCompletion: { (myImage) in
      XCTAssertEqual(myImage, image)
    })
  }
  
  func testGetCachingKey() {
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    let key = GIFCachingService.getCachingKey(fromURL: url)
    XCTAssertEqual(key, url.absoluteString)
  }
  
  func testCacheConfig() {
    XCTAssertEqual(SDImageCache.shared.config.shouldCacheImagesInMemory, true)
    XCTAssertEqual(SDImageCache.shared.config.maxMemoryCost, 10485760)
    XCTAssertEqual(SDImageCache.shared.config.maxMemoryCount, 20)
    XCTAssertEqual(SDImageCache.shared.config.maxDiskSize, 52428800)
    XCTAssertEqual(SDImageCache.shared.config.maxDiskAge, 1296000)
    XCTAssertEqual(SDImageCache.shared.config.diskCacheExpireType, .accessDate)
    XCTAssertEqual(SDImageCache.shared.config.shouldDisableiCloud, true)
  }
  
  func testStoreAndGetImage() {
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    cachingService2?.store(image: image, forUrl: url)
    sleep(5)
    let expectation = self.expectation(description: "fetchImage")
    var result: UIImage?
    cachingService2?.getCachedImage(forUrl: url, withCompletion: { (image) in
      result = image
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
    XCTAssertNotNil(result)
  }
  
  func testStoreAndGetImageFromDisk() {
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    cachingService2?.storeInDisk(image: image, forUrl: url)
    sleep(5)
    let expectation = self.expectation(description: "fetchImage")
    var result: UIImage?
    cachingService2?.getCachedImageFromDisk(forUrl: url, withCompletion: { (image) in
      result = image
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
    XCTAssertNotNil(result)
  }
  
  override func tearDownWithError() throws {
    cachingService = nil
    cachingService2 = nil
  }
  
}
