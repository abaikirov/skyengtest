//
//  API.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
import Alamofire

enum API: BaseRouter {
  case words(_ request: BaseRequest)
  case meanings(_ request: BaseRequest)
  
  var baseURL: String {
    let baseURL: String = try! Configuration.value(for: "BASE_URL")
    return "\(baseURL)/api/public/v1/"
  }
  
  var method: HTTPMethod {
    .get
  }
  
  var path: String {
    switch self {
    case .meanings:
      return "meanings"
    case .words:
      return "words/search"
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case .meanings(let request), .words(let request):
      return request.toParameters()
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var body: Data? {
    return nil
  }
}
