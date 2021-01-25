//
//  GIFMockCachingService.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 25/01/21.
//

import Foundation
import GIFInterfaces
import SDWebImage

struct GIFMockCachingService: GIFCachingInterface {
  func getCachedImage(forUrl url: URL, withCompletion completion: @escaping (UIImage?) -> ()) {
    completion(SDAnimatedImage(named: "panda_mock.gif"))
  }
  
  func store(image: UIImage, forUrl url: URL) {
    
  }
  
  func remove(forUrl url: URL) {
    
  }
  
  func getCachedImageFromDisk(forUrl url: URL, withCompletion completion: @escaping (UIImage?) -> ()) {
    completion(SDAnimatedImage(named: "panda_mock.gif"))
  }
  
  func storeInDisk(image: UIImage, forUrl url: URL) {
    
  }
  
  func removeFromDisk(forUrl url: URL) {
    
  }
  
  
}
