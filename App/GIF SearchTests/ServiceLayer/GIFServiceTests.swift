//
//  GIFServiceTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
import GIFInterfaces
import SDWebImage
@testable import GIF_Search

class GIFServiceTests: XCTestCase {
  var gifService: GIFInterface?
  var gifService2: GIFInterface?
  
  override func setUpWithError() throws {
    let mockCachingService: GIFCachingInterface = GIFMockCachingService()
    self.gifService = GIFMockService(cachingService: mockCachingService)
    self.gifService2 = GIFService(cachingService: mockCachingService)
  }
  
  func testSetImageWithUrl(){
    let imageView = SDAnimatedImageView()
    self.gifService?.setGif(onImageView: imageView, withUrl: URL(string: "test")!, placeholderImage: nil, completion: {
      XCTAssertEqual(imageView.image, SDAnimatedImage(named: "panda_mock.gif"))
    })
  }
  
  func testSetImageWithUrl2() {
    let imageView = SDAnimatedImageView()
    let url: URL = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    self.gifService2?.setGif(onImageView: imageView, withUrl: url, placeholderImage: nil, completion: {
      XCTAssertNotNil(imageView.image)
    })
  }
  
  func testSetImageWithData() {
    let imageView = SDAnimatedImageView()
    self.gifService?.setGif(onImageView: imageView, withData: Data(), completion: {
      XCTAssertEqual(imageView.image, SDAnimatedImage(named: "panda_mock.gif"))
    })
  }
  
  func testSetImageWithData2() {
    let imageView = SDAnimatedImageView()
    self.gifService2?.setGif(onImageView: imageView, withData: Data(), completion: {
      XCTAssertNil(imageView.image)
    })
  }
  
  func testSetImageWithName() {
    let imageView = SDAnimatedImageView()
    self.gifService?.setGif(onImageView: imageView, withName: "", inBundle: nil, completion: {
      XCTAssertEqual(imageView.image, SDAnimatedImage(named: "panda_mock.gif"))
    })
  }
  
  func testSetImageWithName2() {
    let imageView = SDAnimatedImageView()
    self.gifService2?.setGif(onImageView: imageView, withName: "panda_mock.gif", inBundle: nil, completion: {
      XCTAssertEqual(imageView.image, SDAnimatedImage(named: "panda_mock.gif"))
    })
  }
  
  override func tearDownWithError() throws {
    self.gifService = nil
    self.gifService2 = nil
  }
  
}
