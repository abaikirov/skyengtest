//
//  FullMeaning.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

struct FullMeaning: Decodable {
  let id: String
  let wordId: Int
  let partOfSpeechCode: ESpeechCode
  let prefix: String?
  let text: String
  let soundUrl: String
  let transcription: String
  let properties: Properties
  let updatedAt: Date
  let mnemonics: String?
  let translation: Translation
  let images: [Image]
  let definition: Definition
  let examples: [Example]
  let meaningsWithSimilarTranslation: [SimilarMeaning]
  let alternativeTranslations: [AlternativeTranslation]
}
