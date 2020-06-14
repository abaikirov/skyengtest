//
//  TranslateVM.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/13/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

protocol ITranslateVM {
  var translateVC: ITransalteVC? { get set }
  var sectionsCount: Int { get }
  
  func search(_ query: String?)
  func meaning(for section: Int, item: Int) -> Meaning
  func itemsCount(for section: Int) -> Int
  func title(for section: Int) -> String
}

class TranslateVM: ITranslateVM {
  private let networkManager: INetworkManager
  private var words: [Word] = [] {
    didSet {
      if words.isEmpty {
        translateVC?.showEmpty()
      } else {
        translateVC?.hideEmpty()
      }
      translateVC?.updateWords()
    }
  }
  private var searchTimer: Timer?
  private var lastQuery: String?
  
  var sectionsCount: Int {
    words.count
  }
  
  weak var translateVC: ITransalteVC?
  
  init(_ networkManager: INetworkManager) {
    self.networkManager = networkManager
  }
  
  func itemsCount(for section: Int) -> Int {
    words[section].meanings.count
  }
  
  func search(_ query: String?) {
    if lastQuery != query {
      lastQuery = query
      if let query = query, !query.isEmpty {
        translateVC?.showLoading()
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
          self.fetchWords(query)
        })
      } else {
        translateVC?.showStartView()
      }
    }
  }
  
  func title(for section: Int) -> String {
    words[section].text
  }
  
  func meaning(for section: Int, item: Int) -> Meaning {
    words[section].meanings[item]
  }
  
  private func fetchWords(_ query: String) {
    networkManager.words(query, page: nil, pageSize: nil) { (result) in
      self.translateVC?.hideLoading()
      switch result {
      case .success(let words):
        if self.lastQuery == "" {
          self.translateVC?.showStartView()
        } else {
          self.words = words
        }
      case .failure(let error):
        self.translateVC?.showError(error.localizedDescription)
      }
    }
  }
}
