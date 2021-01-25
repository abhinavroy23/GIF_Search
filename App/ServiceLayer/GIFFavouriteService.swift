//
//  GIFFavouriteService.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 25/01/21.
//

import Foundation
import GIFInterfaces

private var favouritesFolder = "favourites"
private var plistName = "favourites.file"

// MARK:- GIFFavouritesService - Concrete object for GIFFavouritesInterface
/// This service implements file system
struct GIFFavouritesService {
  let cachingService: GIFCachingInterface

  init(cachingService: GIFCachingInterface) {
    self.cachingService = cachingService
    configure()
  }
  
  /// Returns documents directory
  private static var documentDirectoryURL: URL {
    do {
      return try FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
      fatalError("Documents directory not found!")
    }
  }
  
  private static var favouritesDirectoryURL: URL {
    /// Returns favourite directory
    let favouritesPath = documentDirectoryURL.appendingPathComponent(favouritesFolder)
    if !FileManager.default.fileExists(atPath: favouritesPath.path) {
      do {
        try FileManager.default.createDirectory(atPath: favouritesPath.path, withIntermediateDirectories: true, attributes: nil)
        return favouritesPath
      } catch {
        fatalError("Unabled to create favourites folder!")
      }
    } else {
      return favouritesPath
    }
  }
  
  /// Returns favourite plist
  private static var favouritesPlistURL: URL {
    let favouritesPlist = favouritesDirectoryURL.appendingPathComponent(plistName)
    if !FileManager.default.fileExists(atPath: favouritesPlist.path) {
        FileManager.default.createFile(atPath: favouritesPlist.path, contents: nil, attributes: nil)
        return favouritesPlist
    } else {
      return favouritesPlist
    }
  }
  private func configure(){
    // Create favourites folder
    _ = GIFFavouritesService.favouritesDirectoryURL
    
    // Create favourite file
    _ = GIFFavouritesService.favouritesPlistURL
    
  }
  
}

// MARK:- Conformance to GIFFavoutiresInterface
extension GIFFavouritesService: GIFFavouritesInterface {
  
  func addToFavourite(image: UIImage, url: URL) {
    let dic = NSMutableArray.init(contentsOfFile: GIFFavouritesService.favouritesPlistURL.path) ?? NSMutableArray()
    if let cachingKey = GIFCachingService.getCachingKey(fromURL: url) {
      dic.add(cachingKey)
      dic.write(toFile: GIFFavouritesService.favouritesPlistURL.path, atomically: true)
      self.cachingService.storeInDisk(image: image, forUrl: url)
    }
  }
  
  func removeFromFavourite(url: URL) {
    if let dic = NSMutableArray.init(contentsOfFile: GIFFavouritesService.favouritesPlistURL.path), let cachingKey = GIFCachingService.getCachingKey(fromURL: url){
      dic.remove(cachingKey)
      dic.write(toFile: GIFFavouritesService.favouritesPlistURL.path, atomically: true)
      self.cachingService.removeFromDisk(forUrl: url)
    }
  }
  
  func getAllCachingKeys() -> [URL] {
    if let dic = NSMutableArray.init(contentsOfFile: GIFFavouritesService.favouritesPlistURL.path) as? [String]{
      return dic.compactMap{ URL(string: $0) }
    }
    return []
  }
  
  func existsInFavourites(url: URL) -> Bool {
    if let dic = NSMutableArray.init(contentsOfFile: GIFFavouritesService.favouritesPlistURL.path) as? [String], let cachinKey = GIFCachingService.getCachingKey(fromURL: url){
      return dic.contains(cachinKey)
    }
    return false
  }
  
  func getImage(forUrl url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
    self.cachingService.getCachedImageFromDisk(forUrl: url) { (image) in
      completion(image)
    }
  }
  
}
