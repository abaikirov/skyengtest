//
//  BaseRouter.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: Parameters? { get }
  var headers: [String: String]? { get }
  var body: Data? { get }
}

extension BaseRouter {
  func asUrl() throws -> URLConvertible {
    let url = try baseURL.asURL()
    return url.appendingPathComponent(path)
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try "\(baseURL)\(path)".asURL()
    var urlRequest = URLRequest(url: url)
    if body != nil {
      urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
    
    if let headers = headers {
      for (key, value) in headers {
        urlRequest.addValue(value, forHTTPHeaderField: key)
      }
    }
    
    if let parameters = parameters {
      if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
        urlComponents.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
          let queryItem = URLQueryItem(name: key, value: "\(value)")
          urlComponents.queryItems?.append(queryItem)
        }
        urlRequest.url = urlComponents.url
      }
    }
    urlRequest.httpMethod = method.rawValue
    urlRequest.httpBody = body
    return urlRequest
  }
}

protocol BaseRequest: Encodable, Parameterized {
  func asUrlRequest() -> URLRequestConvertible
}

protocol Parameterized {
  func toParameters() -> Parameters
}

extension Parameterized where Self: Encodable {
  func toParameters() -> Parameters {
    do {
      let data = try JSONEncoder().encode(self)
      if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        return dict
      }
    } catch {
      print(error)
    }
    return [:]
  }
}
