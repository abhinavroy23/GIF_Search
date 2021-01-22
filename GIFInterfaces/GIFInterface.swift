//
//  GIFInterface.swift
//  Pods
//
//  Created by Roy, Abhinav on 22/01/21.
//

// MARK:- Interfaces related to GIF handling
public protocol GIFInterface {
  
  /// Method to set GIF on a image View
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - url: URL for the image
  func setGif(onImageView imageView: UIImageView, withUrl url: URL)
  
  /// Method to set GIF on a image View
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - data: NSData for the image
  func setGif(onImageView imageView: UIImageView, withData data: Data)
  
  /// Method to set GIF on image view
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - name: name of the image file
  ///   - bundle: Bundle from which the image needs to be rendered
  func setGif(onImageView imageView: UIImageView, withName name: String, inBundle bundle: Bundle?)
  
}

// MARK: - Interfaces related to GIF Caching
public protocol GIFCachingInterface {
  
  /// Returns a cached image form the cache storage - In Memory or Disk
  /// - Parameter url: url corresponding the cached image
  func getCachedImage(forUrl url: URL) -> UIImage?
  
  
  /// store an image in the cache
  /// - Parameters:
  ///   - image: Image to be stored
  ///   - url: url corresponding to the cached image
  func store(image: UIImage, forUrl url: URL)
  
}

