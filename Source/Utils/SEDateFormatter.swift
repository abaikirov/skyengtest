//
//  SEDateFormatter.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

class SEDateFormatter: DateFormatter {
  override init() {
    super.init()
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init()
    setup()
  }
  
  private func setup() {
    dateFormat = "yyyy-MM-dd HH:mm:ss"
    timeZone = TimeZone(abbreviation : "UTC")
  }
}
