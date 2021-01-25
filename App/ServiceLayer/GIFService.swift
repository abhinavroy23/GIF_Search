//
//  GIFService.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 23/01/21.
//

import GIFInterfaces
import SDWebImage

// MARK:- GIF Service : Implementation for GIFInterface - Uses `SDWebImage` factory
struct GIFService: GIFInterface {
  
  let cachingService : GIFCachingInterface
  
  init(cachingService: GIFCachingInterface) {
    self.cachingService = cachingService
  }
  
  /// Method to set GIF on a image View
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - url: URL for the image
  func setGif(onImageView imageView: UIImageView, withUrl url: URL, placeholderImage: UIImage?, completion: @escaping ()->()) {
    guard let imageView = imageView as? SDAnimatedImageView else {
      fatalError("Progressive Images cannot be displayed on UIImageView!")
    }
    
    /// Step1: Check if Image exists in the cache (Mixed Memory & Disk for the best performance - see Configs below in `GIFCachingService`)
    /// Step 2 If yes, set image from the cache
    /// Step 3: If no, download from server and set to cache
    /// --- Since both GIFService & GIFCachingServices are powered by SDWebImage sd_setImage(_:) takes care of both steps 2 and 3
    /// --- If we need to use any other caching service, we can injet it in GIFservice while initializing
    imageView.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.scaleDownLargeImages]) { (_, _, _, _) in
      completion()
    }
  }
  
  /// Method to set GIF on a image View
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - data: NSData for the image
  func setGif(onImageView imageView: UIImageView, withData data: Data) {
    guard let imageView = imageView as? SDAnimatedImageView else {
      fatalError("Progressive Images cannot be displayed on UIImageView!")
    }
    guard let image = SDAnimatedImage.init(data: data) else {
      debugPrint("ERROR: The given data cannot be converted to a progressive image!")
      return
    }
    imageView.image = image
  }
  
  /// Method to set GIF on image view
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - name: name of the image file
  ///   - bundle: Bundle from which the image needs to be rendered
  func setGif(onImageView imageView: UIImageView, withName name: String, inBundle bundle: Bundle?) {
    guard let imageView = imageView as? SDAnimatedImageView else {
      fatalError("Progressive Images cannot be displayed on UIImageView!")
    }
    guard let image = SDAnimatedImage.init(named: name, in: bundle, compatibleWith: nil) else {
      debugPrint("ERROR: No image found for name - \(name) in bundle: \(bundle?.bundlePath ?? "")!")
      return
    }
    imageView.image = image
  }
  
}

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
