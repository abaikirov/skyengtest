//
//  RMeanings.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
import Alamofire

struct RMeanings: BaseRequest {
  let ids: [String]
  let updatedAt: Date
  
  func asUrlRequest() -> URLRequestConvertible {
    try! API.meanings(self).asURLRequest()
  }
}
