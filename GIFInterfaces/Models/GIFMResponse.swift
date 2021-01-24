//
//  GIFMResponse.swift
//  Pods
//
//  Created by Roy, Abhinav on 24/01/21.
//

import Foundation

public struct GIFMResponse: Codable {
  public let data: [GIFMData]
  public let pagination: GIFMPagination
}
