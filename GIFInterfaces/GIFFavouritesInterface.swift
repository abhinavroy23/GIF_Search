//
//  GIFFavouritesInterface.swift
//  Pods
//
//  Created by Roy, Abhinav on 25/01/21.
//

import Foundation

public protocol GIFFavouritesInterface {
  
  /// Add an image to favourite store
  /// - Parameters:
  ///   - image: image to be stored
  ///   - url: url corresponding to the image
  func addToFavourite(image: UIImage, url: URL)
  
  /// Remove an image from the favourite store
  /// - Parameters:
  ///   - image: image to be removed
  ///   - url: url corresponding to the image
  func removeFromFavourite(url: URL)
  
  /// get all favourites urls from store
  func getAllCachingKeys() -> [URL]
  
  /// Check whether an url exists in favourites store
  /// - Parameter url: url
  func existsInFavourites(url: URL) -> Bool
  
  /// Get image corresponding to an url
  /// - Parameter url: caching key correponding to the image
  func getImage(forUrl url: URL, completion: @escaping (_ image : UIImage?) -> ())
  
}
