//
//  GIFNetworkService.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 23/01/21.
//

import NetworkInterfaces

private let InvalidURL: String = "The URL seems to be invalid. Please check and try again!"
private let InvalidData: String = "The data seems to be invalid. Please try again!"

//MARK: Service error
enum GIFNetworkError: Error {
  case invalidUrl
  case invalidData
  
  var description : String{
    switch self {
    case .invalidUrl: return InvalidURL
    case .invalidData: return InvalidData
    }
  }
}

//MARK: Request Type
private enum RequestType: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
}

//MARK: Networking Service - URL Session Client
final class GIFNetworkService: NetworkInterface {
  
  /// Implementation of GET API from `NetworkInterface`
  /// - Parameters:
  ///   - request: Request object that conforms to `Request` protocol
  ///   - session: configurable `URLSession`
  ///   - completion: completion handler, fired on the event of success/failure
  func get(request: Request, session: URLSession = URLSession.shared, completion: @escaping (Result<Data>) -> Void) {
    if let url = request.url{
      session.dataTask(with: url) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
          return
        }
        guard let data = data else {
          completion(.failure(GIFNetworkError.invalidData))
          return
        }
        completion(.success(data))
      }.resume()
    }else{
      completion(.failure(GIFNetworkError.invalidUrl))
    }
  }
  
  /// Implementation of GET API from `NetworkInterface`
  /// - Parameters:
  ///   - request: Request object that conforms to `Request` protocol
  ///   - session: configurable `URLSession`
  ///   - completion: completion handler, fired on the event of success/failure
  func post(request: Request, session: URLSession, completion: @escaping (Result<Data>) -> Void) {
    if let url = request.url{
      var req : URLRequest = URLRequest.init(url: url)
      req.httpMethod = RequestType.post.rawValue
      if let header = request.header{
        for (key,value) in header{
          req.setValue(value, forHTTPHeaderField: key)
        }
      }
      
      if let parameters: [AnyHashable: Any] = request.body {
        do {
          req.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
          completion(.failure(GIFNetworkError.invalidData))
          return
        }
      }
      session.dataTask(with: req) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
          return
        }
        guard let data = data else {
          completion(.failure(GIFNetworkError.invalidData))
          return
        }
        completion(.success(data))
      }.resume()
    }else{
      completion(.failure(GIFNetworkError.invalidUrl))
    }
  }
  
  /// Implementation of GET API from `NetworkInterface`
  /// - Parameters:
  ///   - request: Request object that conforms to `Request` protocol
  ///   - session: configurable `URLSession`
  ///   - completion: completion handler, fired on the event of success/failure
  func put(request: Request, session: URLSession, completion: @escaping (Result<Data>) -> Void) {
    if let url = request.url{
      var req : URLRequest = URLRequest.init(url: url)
      req.httpMethod = RequestType.put.rawValue
      if let header = request.header{
        for (key,value) in header{
          req.setValue(value, forHTTPHeaderField: key)
        }
      }
      
      if let parameters: [AnyHashable: Any] = request.body {
        do {
          req.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
          completion(.failure(GIFNetworkError.invalidData))
          return
        }
      }
      session.dataTask(with: req) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
          return
        }
        guard let data = data else {
          completion(.failure(GIFNetworkError.invalidData))
          return
        }
        completion(.success(data))
      }.resume()
    }else{
      completion(.failure(GIFNetworkError.invalidUrl))
    }
  }
}
