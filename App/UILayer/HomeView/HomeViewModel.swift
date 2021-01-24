//
//  HomeViewModel.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

//MARK: Home View Model
class HomeViewModel {
  
  /// Capabilities
  let gifApiService: GIFAPIInterface
  
  init(apiService: GIFAPIInterface) {
    self.gifApiService = apiService
  }
  
  /// data source
  var trendingDataSource: GIFUIModel = GIFUIModel()
  var searchDataSource: GIFUIModel = GIFUIModel()
  
  /// instance variables
  var isSearchActive: Bool = false
  
}

// MARK:- Conformance to GIFColllctionVMProtocol
extension HomeViewModel: GIFCollectionVMProtocol {
  
  func getDataSource() -> GIFUIModel {
    return isSearchActive ? self.searchDataSource : self.trendingDataSource
  }
  
}

// MARK:- View Model API fetch
extension HomeViewModel {
  typealias UICompletion = (_ sucess: Bool, _ error: Error?) -> ()
  
  func fetchTrending(initialFetch: Bool, withCompletion completion: @escaping UICompletion) {
    let offset = initialFetch ? self.trendingDataSource.offset : self.trendingDataSource.offset + self.trendingDataSource.limit
    gifApiService.fetchTrendingGifs(offset: offset,
                                    limit: self.trendingDataSource.limit) { (result) in
      switch result {
      case .success(let response):
        self.trendingDataSource.updateModel(withDataModel: response)
        completion(true, nil)
      case .failure(let error):
        completion(false, error)
      }
    }
  }
  
  func fetchSearchResults(initialFetch: Bool, forQuery query: String, withCompletion completion: @escaping UICompletion) {
    let offset = initialFetch ? self.searchDataSource.offset : self.searchDataSource.offset + self.trendingDataSource.limit
    gifApiService.searchGifs(searchQuery: query,
                             offset: offset,
                             limit: self.searchDataSource.limit) { (result) in
      switch result {
      case .success(let response):
        self.searchDataSource.updateModel(withDataModel: response)
        completion(true, nil)
      case .failure(let error):
        completion(false, error)
      }
    }
  }
  
}
