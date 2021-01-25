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
  ///   - completion: completion handler
  func setGif(onImageView imageView: UIImageView, withUrl url: URL, placeholderImage: UIImage?, completion: @escaping ()->())
  
  /// Method to set GIF on a image View
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - data: NSData for the image
  ///   - completion: completion handler
  func setGif(onImageView imageView: UIImageView, withData data: Data, completion: @escaping ()->())
  
  /// Method to set GIF on image view
  /// - Parameters:
  ///   - imageView: imageView on which the GIF needs to be shown
  ///   - name: name of the image file
  ///   - bundle: Bundle from which the image needs to be rendered
  ///   - completion: completion handler
  func setGif(onImageView imageView: UIImageView, withName name: String, inBundle bundle: Bundle?, completion: @escaping ()->())
  
}

