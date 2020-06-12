//
//  NetworkManager.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
import Alamofire

protocol INetworkManager {
  
  func words(_ search: String, page: Int?, pageSize: Int?, complition: @escaping (Result<[Word], Error>) -> Void)
}

class NetworkManager: INetworkManager {  
  func words(_ search: String, page: Int?, pageSize: Int?, complition: @escaping (Result<[Word], Error>) -> Void) {
    request(RWords(search: search, page: page, pageSize: pageSize), complition: complition)
  }
  
  private func request<T: Decodable>(_ request: BaseRequest, complition: @escaping (Result<T, Error>) -> Void) {
    ApiClient.request(request) { (response) in
      switch response.result {
      case .success(let data):
        do {
          let decoded = try JSONDecoder().decode(T.self, from: data)
          complition(.success(decoded))
        } catch {
          complition(.failure(error))
        }
      case .failure(let error):
        complition(.failure(error))
      }
    }
  }
}
