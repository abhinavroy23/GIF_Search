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
  func setGif(onImageView imageView: UIImageView, withUrl url: URL) {
    guard let imageView = imageView as? SDAnimatedImageView else {
      fatalError("Progressive Images cannot be displayed on UIImageView!")
    }
    
    // Step 1: Check if image exists in the cache
    guard let image = cachingService.getCachedImage(forUrl: url) else {
      // Step 2: Image does not exist in cache fetch image from server, store in cache and render
      imageView.sd_setImage(with: url) { (image, error, cacheType, url) in
        print("image: \(String(describing: image))")
        print("error: \(String(describing: error))")
        print("cacheType: \(cacheType)")
        print("url: \(String(describing: url))")
      }
      return
    }
    imageView.image = image
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
  static func configureCache() {
    
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
  }
}

// MARK:- Implementation of GIFCachingInterface
extension GIFCachingService: GIFCachingInterface {
  
  func getCachedImage(forUrl url: URL) -> UIImage? {
    return SDImageCache.shared.imageFromCache(forKey: url.absoluteString)
  }
  
  func store(image: UIImage, forUrl url: URL) {
    /// Empty Implementattion for client `SDWebImage`
    /// Storing in cache is handled automatically by `sd_setImage(:_)` method
  }
}
