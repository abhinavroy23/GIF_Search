//
//  GIFAPIMockClient.swift
//  GIF SearchTests
//
//  Created by Roy, Abhinav on 25/01/21.
//

import Foundation
import GIFInterfaces
import GIFNetwork

struct GIFAPIMockClient: GIFAPIInterface {
  
  // MOCK - mock_search.json
  func fetchTrendingGifs(offset: Int, limit: Int, completion: @escaping (Result<GIFMResponse>) -> ()) {
    if let path = Bundle.main.url(forResource: "mock_trending", withExtension: "json") {
      do {
        let data = try Data(contentsOf: path)
        let response = try JSONDecoder().decode(GIFMResponse.self, from: data)
        completion(.success(response))
      } catch {
        completion(.failure(GIFNetworkError.invalidData))
      }
    } else {
      completion(.failure(GIFNetworkError.invalidUrl))
    }
  }
  
  // MOCK - mock_trending.json
  func searchGifs(searchQuery: String, offset: Int, limit: Int, completion: @escaping (Result<GIFMResponse>) -> ()) {
    if let path = Bundle.main.url(forResource: "mock_search", withExtension: "json") {
      do {
        let data = try Data(contentsOf: path)
        let response = try JSONDecoder().decode(GIFMResponse.self, from: data)
        completion(.success(response))
      } catch {
        completion(.failure(GIFNetworkError.invalidData))
      }
    } else {
      completion(.failure(GIFNetworkError.invalidUrl))
    }
  }
}
