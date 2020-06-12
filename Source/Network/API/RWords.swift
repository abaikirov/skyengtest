//
//  RWords.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
import Alamofire

struct RWords: BaseRequest {
  let search: String
  let page: Int?
  let pageSize: Int?
  
  func asUrlRequest() -> URLRequestConvertible {
    try! API.words(self).asURLRequest()
  }
}
