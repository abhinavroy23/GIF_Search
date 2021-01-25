//
//  GIFCollectionViewHandlerTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class GIFCollectionViewHandlerTests: XCTestCase {
  var viewController: HomeViewController!
  var collectionViewHandler: GIFCollectionViewHandler!
  
  override func setUpWithError() throws {
    viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: HomeViewController.self)) as? HomeViewController
    viewController.loadViewIfNeeded()
    collectionViewHandler = viewController.collectionHandler
  }
  
  func testReload() {
    collectionViewHandler.reloadCollectionView()
  }
  
  func testNumberOfRows() {
    sleep(3)
    let rows = collectionViewHandler.collectionView(collectionViewHandler.collectionView, numberOfItemsInSection: 0)
    XCTAssertGreaterThan(rows, 0)
  }
  
  func testCellForItemAt() {
    sleep(3)
    let cell = collectionViewHandler.collectionView(collectionViewHandler.collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
    XCTAssertNotNil(cell)
  }
  
  func testSizeForLayout() {
    sleep(3)
    let size = collectionViewHandler.collectionView(collectionViewHandler.collectionView, layout: UICollectionViewLayout(), sizeForItemAt: IndexPath(row: 0, section: 0))
    if UIDevice.current.userInterfaceIdiom == .pad {
      let requiredWidth = UIScreen.main.bounds.size.width/3 - 13.6
      XCTAssertEqual(size, CGSize.init(width: requiredWidth, height: requiredWidth))
    } else {
      let requiredWidth = UIScreen.main.bounds.size.width/2 - 15
      XCTAssertEqual(size, CGSize.init(width: requiredWidth, height: requiredWidth))
    }
  }
  
  func testInsetForSection() {
    sleep(3)
    let inset = collectionViewHandler.collectionView(collectionViewHandler.collectionView, layout: UICollectionViewLayout(), insetForSectionAt: 0)
    XCTAssertEqual(inset, UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10))
  }
  
  override func tearDownWithError() throws {
    self.viewController = nil
    self.collectionViewHandler = nil
  }
  
}
