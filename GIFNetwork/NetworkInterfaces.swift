//
//  NetworkInterfaces.swift
//  Pods
//
//  Created by Roy, Abhinav on 22/01/21.
//

//MARK: Result enum
/// Result enum with success and failure components
public enum Result<Value> {
  case success(Value)
  case failure(Error)
}

//MARK: Requests protocol
/// Describes components of a request
/// URL - URL of the request
/// header - header of the request in standard format [String: String]
/// body - dictionary body of the reuqest in the format [String: AnyHashable]
public protocol Request {
  var url: URL? { get }
  var header : [String : String]? { get }
  var body : [String : AnyHashable]? { get }
}

//MARK: Service protocol
public protocol NetworkInterface {
  
  /// REST API - GET Method
  /// - Parameters:
  ///   - request: Request object that conforms to `Request` protocol
  ///   - session: configurable `URLSession`
  ///   - completion: completion handler, fired on the event of success/failure
  func get(request: Request, session: URLSession, completion: @escaping (Result<Data>) -> Void)
  
  
  /// REST API - POST Method
  /// - Parameters:
  ///   - request: Request object that conforms to `Request` protocol
  ///   - session: configurable `URLSession`
  ///   - completion: completion handler, fired on the event of success/failure
  func post(request: Request, session: URLSession, completion: @escaping (Result<Data>) -> Void)
  
  
  /// REST API - PUT Method
  /// - Parameters:
  ///   - request: Request object that conforms to `Request` protocol
  ///   - session: configurable `URLSession`
  ///   - completion: completion handler, fired on the event of success/failure
  func put(request: Request, session: URLSession, completion: @escaping (Result<Data>) -> Void)
}
