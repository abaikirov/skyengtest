//
//  ESpeechCode.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

enum ESpeechCode: String, Decodable {
  case noun = "n"
  case verb = "v"
  case adjective = "j"
  case adverb = "r"
  case preposition = "prp"
  case pronoun = "prn"
  case cardinalNumber = "crd"
  case conjunction = "cjc"
  case interjection = "exc"
  case article = "det"
  case abbreviation = "abb"
  case particle = "x"
  case ordinalNumber = "ord"
  case modalVerb = "md"
  case phrase = "ph"
  case idiom = "phi"
}
