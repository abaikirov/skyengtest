//
//  MockError.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

enum MockError: LocalizedError {
  case network
  
  var errorDescription: String? {
    "network"
  }
}
