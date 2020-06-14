//
//  TransalateVMTests.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/13/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import XCTest
@testable import SkyEngTest

class TranslateVMTests: XCTestCase {
  
  var networkManager: MockNetworkManager!
  var vm: TranslateVM!
  var vc: MockTranslateVC!
  
  override func setUp() {
    super.setUp()
    networkManager = MockNetworkManager()
    vm = TranslateVM(networkManager)
    vc = MockTranslateVC()
    vm.translateVC = vc
  }
  
  override func tearDown() {
    networkManager = nil
    vm = nil
    vc = nil
  }
  
  func test_search() {
    networkManager.isWordsCalled = false
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    XCTAssert(networkManager.isWordsCalled)
  }
  
  func test_empty() {
    vc.isEmptyCalled = false
    networkManager.isWordsCalled = false
    vc.showEmptyExpectation = XCTestExpectation(description: "show empty")
    vm.search("empty")
    wait(for: [vc.showEmptyExpectation!], timeout: 0.5)
    XCTAssert(networkManager.isWordsCalled)
    XCTAssert(vc.isEmptyCalled)
  }
  
  func test_error() {
    vc.errorMessage = nil
    vc.showErrorExpectation = XCTestExpectation(description: "show error")
    vm.search("error")
    wait(for: [vc.showErrorExpectation!], timeout: 0.5)
    XCTAssertEqual(vc.errorMessage, "network")
  }
  
  func test_sectionsCount() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    XCTAssertEqual(vm.sectionsCount, 10)
  }
  
  func test_meaningsCountForFirstSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    XCTAssertEqual(vm.itemsCount(for: 0), 6)
  }
  
  func test_meaningsCountForSecondSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    XCTAssertEqual(vm.itemsCount(for: 1), 2)
  }
  
  func test_titleForFirstSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    XCTAssertEqual(vm.title(for: 0), "word")
  }
  
  func test_titleForSecondSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    XCTAssertEqual(vm.title(for: 1), "particle")
  }
  
  func test_firstMeaningInFirstSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    let meaning = vm.meaning(for: 0, item: 0)
    XCTAssertEqual(meaning.id, 92160)
    XCTAssertEqual(meaning.translation.text, "слово")
  }
  
  func test_secondMeaningInFirstSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    let meaning = vm.meaning(for: 0, item: 1)
    XCTAssertEqual(meaning.id, 92162)
    XCTAssertEqual(meaning.translation.text, "известие")
  }
  
  func test_firstMeaningInSecondSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    let meaning = vm.meaning(for: 1, item: 0)
    XCTAssertEqual(meaning.id, 109102)
    XCTAssertEqual(meaning.translation.text, "частица")
  }
  
  func test_SecondMeaningInSecondSection() {
    vc.updateWordsExpectation = XCTestExpectation(description: "update words")
    vm.search("test")
    wait(for: [vc.updateWordsExpectation!], timeout: 0.5)
    let meaning = vm.meaning(for: 1, item: 1)
    XCTAssertEqual(meaning.id, 109104)
    XCTAssertEqual(meaning.translation.text, "служебное слово")
  }
}

class MockTranslateVC: ITransalteVC {
  var isEmptyCalled = false
  var errorMessage: String?
  
  var updateWordsExpectation: XCTestExpectation?
  var showEmptyExpectation: XCTestExpectation?
  var showErrorExpectation: XCTestExpectation?
  
  func updateWords() {
    updateWordsExpectation?.fulfill()
  }
  
  func showEmpty() {
    showEmptyExpectation?.fulfill()
    isEmptyCalled = true
  }
  
  func showError(_ message: String) {
    showErrorExpectation?.fulfill()
    errorMessage = message
  }
}
