//
//  GIFAPIClient.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 23/01/21.
//

import Foundation
import NetworkInterfaces
import GIFInterfaces
import GIFFoundation

private let GIFApiKey_Encoded: String = "ZHRUbDR5eFVYa3F1OG9OdEJVd2V2WUtjdGRnYW5mdjU="
private let baseURL_Encoded: String = "aHR0cHM6Ly9hcGkuZ2lwaHkuY29tL3YxL2dpZnM="
private let random_id: String = "2740b473600db7ca466d74686fddb3d4"

// MARK:- GIFAPIRequest - Conformance to `Request` Procotol from `NetworkInterfaces`
enum GIFAPIRequest: Request {
  case trendingGifs(offset: Int, limit: Int)
  case searchGifs(searchQuery: String, offset: Int, limit: Int)
  
  /// Provide `URL` for each request
  var url: URL? {
    let baseUrl = baseURL_Encoded.base64Decoded()
    let apiKey = GIFApiKey_Encoded.base64Decoded()
    switch self {
    case .trendingGifs(let offset, let limit):
      return URL(string: "\(baseUrl)/trending?api_key=\(apiKey)&offset=\(offset)&limit=\(limit)&random_id=\(random_id)")
    case .searchGifs(let query, let offset, let limit):
      return URL(string:"\(baseUrl)/search?api_key=\(apiKey)&q=\(query)&offset=\(offset)&limit=\(limit)&random_id=\(random_id)")
    }
  }
  
  /// Provide `Header` for each request
  var header: [String : String]? {
    switch self {
    case .trendingGifs(_, _), .searchGifs(_, _, _): return nil
    }
  }
  
  /// Provide `Reuqest Body` for each request
  var body: [String : AnyHashable]? {
    switch self {
    case .trendingGifs(_, _), .searchGifs(_, _, _): return nil
    }
  }
}

// MARK:- GIFAPIInteraface - endpoints for GIF network calls
protocol GIFAPIInterface {
  
  /// Fetch Trending GIFs
  /// - Parameters:
  ///   - offset: offset for pagination
  ///   - limit: limit for pagination
  ///   - completion: completion handler for response
  func fetchTrendingGifs(offset: Int, limit: Int, completion: @escaping (Result<GIFMResponse>) -> ())
  
  /// Fetch GIFs as per the search query
  /// - Parameters:
  ///   - searchQuery: query for the search
  ///   - offset: offset for pagination
  ///   - limit: limit for pagination
  ///   - completion: completion handler for response
  func searchGifs(searchQuery: String, offset: Int, limit: Int, completion: @escaping (Result<GIFMResponse>) -> ())
}

// MARK:- GIFAPIService - Conformance to `GIFAPIInterface`
struct GIFAPIService: GIFAPIInterface {
  var networkService: NetworkInterface
  
  init(networkService: NetworkInterface) {
    self.networkService = networkService
  }
  
  /// Fetch Trending GIFs
  /// - Parameters:
  ///   - offset: offset for pagination
  ///   - limit: limit for pagination
  ///   - completion: completion handler for response
  func fetchTrendingGifs(offset: Int, limit: Int, completion: @escaping (Result<GIFMResponse>) -> ()) {
    let request = GIFAPIRequest.trendingGifs(offset: offset, limit: limit)
    networkService.get(request: request, session: URLSession.shared) { (result) in
      switch result {
      case .success(let data):
        do {
          let responseModel = try JSONDecoder().decode(GIFMResponse.self, from: data)
          completion(.success(responseModel))
        } catch {
          completion(.failure(GIFClientError.unableToFetchData))
        }
      case .failure(_):
        completion(.failure(GIFClientError.unableToFetchData))
      }
    }
  }
  
  /// Fetch GIFs as per the search query
  /// - Parameters:
  ///   - searchQuery: query for the search
  ///   - offset: offset for pagination
  ///   - limit: limit for pagination
  ///   - completion: completion handler for response
  func searchGifs(searchQuery: String, offset: Int, limit: Int, completion: @escaping (Result<GIFMResponse>) -> ()) {
    let request = GIFAPIRequest.searchGifs(searchQuery: searchQuery, offset: offset, limit: limit)
    networkService.get(request: request, session: URLSession.shared) { (result) in
      switch result {
      case .success(let data):
        do {
          let responseModel = try JSONDecoder().decode(GIFMResponse.self, from: data)
          completion(.success(responseModel))
        } catch {
          completion(.failure(GIFClientError.unableToFetchData))
        }
      case .failure(_):
        completion(.failure(GIFClientError.unableToFetchData))
      }
    }
  }
  
}

// MARK:- Clinet errors
enum GIFClientError: Error {
  case unableToFetchData
  
  var description: String {
    switch self {
    case .unableToFetchData: return "Unable to fetch data. Pelase try again!"
    }
  }
}
