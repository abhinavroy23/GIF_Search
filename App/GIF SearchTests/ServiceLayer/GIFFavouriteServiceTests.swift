//
//  GIFFavouriteServiceTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
import GIFInterfaces
import SDWebImage
@testable import GIF_Search

class GIFFavouriteServiceTests: XCTestCase {
  var favouriteService: GIFFavouritesInterface?
  let mockCachingService: GIFCachingInterface = GIFMockCachingService()
  
  override func setUpWithError() throws {
    favouriteService = GIFFavouritesService(cachingService: mockCachingService)
  }
  
  func testAddToFavourite() {
    favouriteService = GIFFavouritesService(cachingService: mockCachingService) // flush file
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    favouriteService?.addToFavourite(image: image, url: url)
    XCTAssertEqual(favouriteService?.getAllCachingKeys().count, 1)
  }
  
  func testRemoveFromFavourites() {
    favouriteService = GIFFavouritesService(cachingService: mockCachingService) // flush file
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    favouriteService?.addToFavourite(image: image, url: url)
    XCTAssertEqual(favouriteService?.getAllCachingKeys().count, 1)
    favouriteService?.removeFromFavourite(url: url)
    XCTAssertEqual(favouriteService?.getAllCachingKeys().count, 0)
  }
  
  func testExistsInFavourites() {
    favouriteService = GIFFavouritesService(cachingService: mockCachingService) // flush file
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    favouriteService?.addToFavourite(image: image, url: url)
    XCTAssertNotNil(favouriteService?.existsInFavourites(url: url))
    XCTAssertTrue(favouriteService!.existsInFavourites(url: url))
  }
  
  func testGetImage() {
    favouriteService = GIFFavouritesService(cachingService: mockCachingService) // flush file
    let image = SDAnimatedImage(named: "panda_mock.gif")!
    let url = URL(string: "https://media.giphy.com/media/KyBX9ektgXWve/source.gif")!
    favouriteService?.addToFavourite(image: image, url: url)
    XCTAssertNotNil(favouriteService?.existsInFavourites(url: url))
    favouriteService?.getImage(forUrl: url, completion: { (newImage) in
      XCTAssertEqual(image, newImage)
    })
  }
  
  override func tearDownWithError() throws {
    self.favouriteService = nil
  }
  
}
