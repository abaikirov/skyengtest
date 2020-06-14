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
  func words(_ search: String, page: Int?, pageSize: Int?, completion: @escaping (Result<[Word], Error>) -> Void)
  func meanings(_ meaningIds: [Int], from date: Date, completion: @escaping(Result<[FullMeaning], Error>) -> Void)
}

class NetworkManager: INetworkManager {
  func meanings(_ meaningIds: [Int], from date: Date, completion: @escaping (Result<[FullMeaning], Error>) -> Void) {
    var ids = meaningIds.reduce("") { res, id in "\(res),\(id)" }
    ids.remove(at: ids.startIndex)
    request(RMeanings(ids: ids, updatedAt: date), completion: completion)
  }
  
  func words(_ search: String, page: Int?, pageSize: Int?, completion: @escaping (Result<[Word], Error>) -> Void) {
    request(RWords(search: search, page: page, pageSize: pageSize), completion: completion)
  }
  
  private func request<T: Decodable>(_ request: BaseRequest, completion: @escaping (Result<T, Error>) -> Void) {    
    ApiClient.request(request) { (response) in
      switch response.result {
      case .success(let data):
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .formatted(SEDateFormatter())
          let decoded = try decoder.decode(T.self, from: data)
          completion(.success(decoded))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
