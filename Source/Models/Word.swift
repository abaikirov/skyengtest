//
//  Word.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

struct Word: Decodable {
  let id: Int
  let text: String
  let meanings: [Meaning]
}
