//
//  GIFUIModel.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import Foundation
import GIFInterfaces

//MARK: UI Model - Simplified
struct GIFUIModel {
  var gifs: [GIFUIResult] = [GIFUIResult]()
  var offset: Int = 1
  var limit: Int = 20
  
  /// Empty initializer
  init() {}
  
  /// Initailizer for GIFUIModel - for trending & search
  init(gifDataModel: GIFMResponse) {
    self.offset = gifDataModel.pagination.offset
    self.limit = gifDataModel.pagination.count
    self.gifs = [GIFUIResult]()
    self.gifs.append(contentsOf: gifDataModel.data.compactMap { GIFUIResult(gifData: $0) })
  }
  
  /// Initiazer for GIFUIModel - for favourites
  init(withGifUrls gifUrls: [String]) {
    self.gifs = [GIFUIResult]()
    self.gifs.append(contentsOf: gifUrls.compactMap { GIFUIResult(withGifUrl: $0) })
  }
  
  /// Function to update data model with more pagination data
  mutating func updateModel(withDataModel gifDataModel: GIFMResponse) {
    self.offset = gifDataModel.pagination.offset
    self.limit = gifDataModel.pagination.count
    self.gifs.append(contentsOf: gifDataModel.data.compactMap { GIFUIResult(gifData: $0) })
  }
}

struct GIFUIResult {
  var name: String
  var url: URL
  
  // Init with Model data - for trending & search
  init?(gifData: GIFMData) {
    /// set name
    self.name = gifData.title
    
    /// check if downsized image url is present
    /// if yes - set downsized image url
    /// if no - set original image url
    guard let downsized = gifData.images.downsized, let downSizedUrl = URL(string: downsized.url) else {
      guard let originalUrl = URL(string: gifData.images.original.url) else {
        return nil
      }
      self.url = originalUrl
      return
    }
    self.url = downSizedUrl
  }
  
  // Init with url - for favourites
  init?(withGifUrl gifUrl: String) {
    self.name = ""
    guard let url = URL(string: gifUrl) else {
      return nil
    }
    self.url = url
  }
}


