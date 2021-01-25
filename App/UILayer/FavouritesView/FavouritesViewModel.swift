//
//  FavouritesViewModel.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import Foundation
import GIFInterfaces

class FavouritesViewModel {
  
  var favouriteService: GIFFavouritesInterface

  
  var dataSource: GIFUIModel = GIFUIModel()
  
  init(favouriteService: GIFFavouritesInterface) {
    self.favouriteService = favouriteService
  }
  
  func fetchFavourites(withCompletion completion: () -> ()) {
    let urls = favouriteService.getAllCachingKeys()
    // Process cachingkeys to make UI compliant model
    self.dataSource = GIFUIModel.init(withGifUrls: urls.map { $0.absoluteString })
    completion()
  }
}

// MARK:- Conformance to GIFColllctionVMProtocol
extension FavouritesViewModel: GIFCollectionVMProtocol {
  
  func getDataSource() -> GIFUIModel {
    return self.dataSource
  }
  
}
