//
//  MockNetworkManager.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
@testable import SkyEngTest

class MockNetworkManager: INetworkManager {
  var isWordsCalled = false
  var isMeaningsCalled = false
  
  func words(_ search: String, page: Int?, pageSize: Int?, completion: @escaping (Result<[Word], Error>) -> Void) {
    isWordsCalled = true
    if search == "empty" {
      completion(.success([]))
    } else if search == "error" {
      completion(.failure(MockError.network))
    } else {
      let path = Bundle(for: type(of: self)).path(forResource: "words", ofType: "json")!
      let data = try! Data(contentsOf: URL(fileURLWithPath: path))
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(SEDateFormatter())
      let words = try! decoder.decode([Word].self, from: data)
      completion(.success(words))
    }
  }
  
  func meanings(_ meaningIds: [Int], from date: Date, completion: @escaping (Result<[FullMeaning], Error>) -> Void) {
    if meaningIds.contains(0) {
      completion(.success([]))
    } else if meaningIds.contains(-1) {
      completion(.failure(MockError.network))
    } else {
      let path = Bundle(for: type(of: self)).path(forResource: "meaning", ofType: "json")!
      let data = try! Data(contentsOf: URL(fileURLWithPath: path))
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(SEDateFormatter())
      let fullMeanings = try! decoder.decode([FullMeaning].self, from: data)
      completion(.success(fullMeanings))
    }
  }
}
