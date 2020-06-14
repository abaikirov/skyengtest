//
//  MockMeaningVC.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation
@testable import SkyEngTest

class MockMeaningVC: IMeaningVC {
  var isShowMeaningCalled = false
  var isShowEmptyCalled = false
  var isShowErrorCalled = false
  
  var errorMessage: String?
  
  func showMeaning(_ fullMeaning: FullMeaning) {
    isShowMeaningCalled = true
  }
  
  func showEmpty() {
    isShowEmptyCalled = true
  }
  
  func showError(_ message: String) {
    isShowErrorCalled = true
    errorMessage = message
  }
}
