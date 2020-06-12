//
//  Properties.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

struct Properties: Decodable {
  let collocation: Bool
  let countability: String
  let irregularPlural: Bool
  let falseFriends: [String]
}
