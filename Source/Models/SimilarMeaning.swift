//
//  SimilarMeaning.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

struct SimilarMeaning: Decodable {
  let meaningId: Int
  let frequencyPercent: String
  let partOfSpeechAbbreviation: String
  let translation: Translation
}
