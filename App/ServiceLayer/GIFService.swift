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
  func setGif(onImageView imageView: UIImageView, withData data: Data, completion: @escaping ()->()) {
    guard let imageView = imageView as? SDAnimatedImageView else {
      completion()
      fatalError("Progressive Images cannot be displayed on UIImageView!")
    }
    guard let image = SDAnimatedImage.init(data: data) else {
      completion()
      debugPrint("ERROR: The given data cannot be converted to a progressive image!")
      return
    }
    imageView.image = image
    completion()
  }
  
  /// Method to set GIF on image view
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - name: name of the image file
  ///   - bundle: Bundle from which the image needs to be rendered
  func setGif(onImageView imageView: UIImageView, withName name: String, inBundle bundle: Bundle?, completion: @escaping ()->()) {
    guard let imageView = imageView as? SDAnimatedImageView else {
      completion()
      fatalError("Progressive Images cannot be displayed on UIImageView!")
    }
    guard let image = SDAnimatedImage.init(named: name, in: bundle, compatibleWith: nil) else {
      debugPrint("ERROR: No image found for name - \(name) in bundle: \(bundle?.bundlePath ?? "")!")
      completion()
      return
    }
    imageView.image = image
    completion()
  }
  
}
