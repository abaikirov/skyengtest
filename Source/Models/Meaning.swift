//
//  Meaning.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

struct Meaning: Decodable {
  let id: Int
  let partOfSpeechCode: ESpeechCode?
  let translation: Translation
  let previewUrl: String
  let imageUrl: String
  let soundUrl: String
}
