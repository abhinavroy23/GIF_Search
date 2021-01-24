//
//  FavouritesViewModel.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import Foundation

struct FavouritesViewModel {
  
  var dataSource: GIFUIModel = GIFUIModel()
  
}

// MARK:- Conformance to GIFColllctionVMProtocol
extension FavouritesViewModel: GIFCollectionVMProtocol {
  
  func getDataSource() -> GIFUIModel {
    return self.dataSource
  }
  
}
