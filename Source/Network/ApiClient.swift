//
//  ApiClient.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient {
  static func request(_ request: BaseRequest, completion: @escaping (AFDataResponse<Data>) -> Void) {
    AF.request(request.asUrlRequest()).responseData(completionHandler: completion)
  }
}

