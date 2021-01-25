//
//  GIFMockService.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 25/01/21.
//

import Foundation
import GIFInterfaces
import SDWebImage

struct GIFMockService: GIFInterface {
  let cachingService: GIFCachingInterface
  
  init(cachingService: GIFCachingInterface) {
    self.cachingService = cachingService
  }
  
  func setGif(onImageView imageView: UIImageView, withUrl url: URL, placeholderImage: UIImage?, completion: @escaping () -> ()) {
    cachingService.getCachedImage(forUrl: url) { (image) in
      imageView.image = image
      completion()
    }
  }
  
  func setGif(onImageView imageView: UIImageView, withData data: Data, completion: @escaping ()->()) {
    cachingService.getCachedImage(forUrl: URL(string: "test")!) { (image) in
      imageView.image = image
      completion()
    }
  }
  
  func setGif(onImageView imageView: UIImageView, withName name: String, inBundle bundle: Bundle?, completion: @escaping ()->()) {
    cachingService.getCachedImage(forUrl: URL(string: "test")!) { (image) in
      imageView.image = image
      completion()
    }
  }
  
  
}


