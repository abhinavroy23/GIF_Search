//
//  GIFCellTests.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class GIFCellTests: XCTestCase {
  var viewController: HomeViewController!
  var collectionViewHandler: GIFCollectionViewHandler!
  var cell: GIFCell?
  
  override func setUpWithError() throws {
    viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: HomeViewController.self)) as? HomeViewController
    viewController.loadViewIfNeeded()
    collectionViewHandler = viewController.collectionHandler
    sleep(5)
    cell = collectionViewHandler.collectionView(collectionViewHandler.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? GIFCell
  }
  
  func testAwakeFromNib() {
    cell?.awakeFromNib()
    XCTAssertEqual(cell?.layer.cornerRadius, 7.0)
    XCTAssertEqual(cell?.layer.masksToBounds, true)
    XCTAssertEqual(cell?.gifImageView.image, UIImage.singleLoader)
    XCTAssertEqual(cell?.favouriteButton.isEnabled, false)
  }
  
  func testPrepareForReuse() {
    cell?.prepareForReuse()
    XCTAssertEqual(cell?.favouriteButton.isSelected, false)
    XCTAssertEqual(cell?.gifImageView.image, UIImage.singleLoader)
    XCTAssertEqual(cell?.favouriteButton.isEnabled, false)
  }
  
  func testConfigureCell() {
    cell?.configureCell(withUrl: URL(string: "test")!, gifService: collectionViewHandler.gifService, delegate: collectionViewHandler, indexPath: IndexPath(row: 0, section: 0))
    XCTAssertNotNil(cell?.delegate)
  }
  
  override func tearDownWithError() throws {
    self.viewController = nil
    self.collectionViewHandler = nil
    self.cell = nil
  }
}
