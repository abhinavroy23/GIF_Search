//
//  String+Encoding.swift
//  Pods
//
//  Created by Roy, Abhinav on 24/01/21.
//

import Foundation

public extension String {
  
  func base64Encoded() -> String {
    guard let result = data(using: .utf8)?.base64EncodedString()  else {
      fatalError("Unable to encode to base 64!")
    }
    return result
  }
  
  func base64Decoded() -> String {
    guard let data = Data(base64Encoded: self), let result = String(data: data, encoding: .utf8) else {
      fatalError("Unable to decode to base 64!")
    }
    return result
  }
  
}
