//
//  UIImage+App.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import XCTest
@testable import GIF_Search

class UIImage_AppTests: XCTestCase {
  
  func testThreeLoader() {
    let image = UIImage.threeLoader
    XCTAssertNotNil(image)
  }
  
  func testOneLoader() {
    let image = UIImage.singleLoader
    XCTAssertNotNil(image)
  }
  
}
