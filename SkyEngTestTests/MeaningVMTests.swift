//
//  MeaningVMTests.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import XCTest
@testable import SkyEngTest

class MeaningVMTests: XCTestCase {
  
  var networkManager: MockNetworkManager!
  var vm: MeaningVM!
  var vc: MockMeaningVC!
  
  var normalMeaning = Meaning(id: 1, partOfSpeechCode: nil, translation: Translation(text: "test", note: nil), previewUrl: "", imageUrl: "", soundUrl: "")
  
  override func setUp() {
    super.setUp()
    networkManager = MockNetworkManager()
    vc = MockMeaningVC()
    vm = MeaningVM(meaning: normalMeaning, networkManager: networkManager)
    vm.meaningVC = vc
  }
  
  override func tearDown() {
    networkManager = nil
    vm = nil
    vc = nil
  }
  
  func test_fetchMeanings() {
    vc.isShowMeaningCalled = false
    vm.fetchMeanings()
    XCTAssert(vc.isShowMeaningCalled)
  }
}
