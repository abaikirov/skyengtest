//
//  EmptyMeaningVMTests.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import XCTest
@testable import SkyEngTest

class EmptyMeaningVMTests: XCTestCase {
  
  var networkManager: MockNetworkManager!
  var vm: MeaningVM!
  var vc: MockMeaningVC!
  
  var emptyMeaning = Meaning(id: 0, partOfSpeechCode: nil, translation: Translation(text: "test", note: nil), previewUrl: "", imageUrl: "", soundUrl: "")
  
  override func setUp() {
    super.setUp()
    networkManager = MockNetworkManager()
    vm = MeaningVM(meaning: emptyMeaning, networkManager: networkManager)
    vc = MockMeaningVC()
    vm.meaningVC = vc
  }
  
  override func tearDown() {
    networkManager = nil
    vm = nil
    vc = nil
  }
  
  func test_empty() {
    vc.isShowEmptyCalled = false
    vm.fetchMeanings()
    XCTAssert(vc.isShowEmptyCalled)
  }
}

