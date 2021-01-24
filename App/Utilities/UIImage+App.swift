//
//  UIImage+App.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 23/01/21.
//

import UIKit
import SDWebImage

// MARK:- UIImage extension - Limited to GIF Search app
extension UIImage {
    
  /// Three Loader
  class var threeLoader: SDAnimatedImage? {
    get { SDAnimatedImage.init(named: "loader_three_circle.gif") }
  }
  
  /// Single Loader
  class var singleLoader: SDAnimatedImage? {
    get { SDAnimatedImage.init(named: "loader_one_circle.gif") }
  }
  
}
