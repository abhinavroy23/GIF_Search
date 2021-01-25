//
//  GIFCachingService.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 25/01/21.
//

import Foundation
import GIFInterfaces
import SDWebImage

// MARK:- GIF Caching Service - Implementation for GIFCachingService - Uses `SDImageCache` factory
struct GIFCachingService {
  
  init() {
    self.configureCache()
  }
  
  func configureCache() {
    
    /// Store some images  in memory for faster access
    SDImageCache.shared.config.shouldCacheImagesInMemory = true
    
    /// Limit for memory cache - `Max 10 MB` in memory, If the limit exceeds it will start using `Disk cache`
    SDImageCache.shared.config.maxMemoryCost = 10485760
    
    /// Limit of files for memory acche- `Max 20 Items`, If the limit exceeds it will start using `Disk cache`
    SDImageCache.shared.config.maxMemoryCount = 20
    
    /// Limit for Disk cache- `Max 50 MB`, If full remove the least recently used item from cache
    SDImageCache.shared.config.maxDiskSize = 52428800
    
    /// Expiration for disk cache items - `Max 15 days`
    SDImageCache.shared.config.maxDiskAge = 1296000
    
    /// The item with maximum access date will be removed first
    SDImageCache.shared.config.diskCacheExpireType = .accessDate
    
    /// Don't use iCloud to store image, store locally on device
    SDImageCache.shared.config.shouldDisableiCloud = true
    
    /// Set custom cache key
    SDWebImageManager.shared.cacheKeyFilter = SDWebImageCacheKeyFilter.init(block: { (url) -> String? in
      GIFCachingService.getCachingKey(fromURL: url)
    })
  }
  
  static func getCachingKey(fromURL url: URL?) -> String? {
    guard let url = url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
    urlComponents.query = nil
    guard let newUrl = urlComponents.url else { return nil }
    return newUrl.absoluteString
  }
}

// MARK:- Implementation of GIFCachingInterface
extension GIFCachingService: GIFCachingInterface {
  
  func getCachedImage(forUrl url: URL, withCompletion completion: @escaping (_ image: UIImage?) -> ()) {
    DispatchQueue.global(qos: .background).async {
      guard let cachingKey = GIFCachingService.getCachingKey(fromURL: url) else {
        completion(nil)
        return
      }
      let image = SDImageCache.shared.imageFromCache(forKey: cachingKey)
      completion(image)
    }
  }
  
  func store(image: UIImage, forUrl url: URL) {
    DispatchQueue.global(qos: .background).async {
      if let cachingKey = GIFCachingService.getCachingKey(fromURL: url) {
        SDImageCache.shared.store(image, forKey: cachingKey, completion: nil)
      }
    }
  }
  
  func remove(forUrl url: URL) {
    DispatchQueue.global(qos: .background).async {
      if let cachingKey = GIFCachingService.getCachingKey(fromURL: url) {
        SDImageCache.shared.removeImage(forKey: cachingKey, withCompletion: nil)
      }
    }
  }
  
  func getCachedImageFromDisk(forUrl url: URL, withCompletion completion: @escaping (UIImage?) -> ()) {
    DispatchQueue.global(qos: .background).async {
      guard let cachingKey = GIFCachingService.getCachingKey(fromURL: url) else {
        completion(nil)
        return
      }
      let image = SDImageCache.shared.imageFromDiskCache(forKey: cachingKey)
      completion(image)
    }
  }
  
  func storeInDisk(image: UIImage, forUrl url: URL) {
    DispatchQueue.global(qos: .background).async {
      if let cachingKey = GIFCachingService.getCachingKey(fromURL: url), let imageData = image.sd_imageData(){
        SDImageCache.shared.storeImageData(toDisk: imageData, forKey: cachingKey)
      }
    }
  }
  
  func removeFromDisk(forUrl url: URL) {
    DispatchQueue.global(qos: .background).async {
      if let cachingKey = GIFCachingService.getCachingKey(fromURL: url) {
        SDImageCache.shared.removeImageFromDisk(forKey: cachingKey)
      }
    }
  }
}
