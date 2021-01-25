//
//  GIFCachingInterface.swift
//  Pods
//
//  Created by Roy, Abhinav on 25/01/21.
//
import UIKit

// MARK: - Interfaces related to GIF Caching
public protocol GIFCachingInterface {
  
  /// Returns a cached image form the cache storage - In Memory or Disk
  /// - Parameter url: url corresponding the cached image
  /// - Parameter completion: Completion handler that returns the cached image
  func getCachedImage(forUrl url: URL, withCompletion completion: @escaping (_ image: UIImage?) -> ())
  
  /// store an image in the cache - In Memory or Disk
  /// - Parameters:
  ///   - image: Image to be stored
  ///   - url: url corresponding to the cached image
  func store(image: UIImage, forUrl url: URL)
  
  /// Remove image from cache for an url
  /// - Parameter url: url
  func remove(forUrl url: URL)
  
  /// Returns a cached image from DISK
  /// - Parameters:
  ///   - url: url corresponding to the cached iamge
  ///   - completion: completion handler that returns the cached image
  func getCachedImageFromDisk(forUrl url: URL, withCompletion completion: @escaping (_ image: UIImage?) -> ())
  
  /// store an image in the DISK cache
  /// - Parameters:
  ///   - image: Image to be stored
  ///   - url: url corresponding to the cached image
  func storeInDisk(image: UIImage, forUrl url: URL)
  
  /// Remove an image from DISK
  /// - Parameter url: url
  func removeFromDisk(forUrl url: URL)
}
