//
//  MeaningVM.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/13/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

protocol IMeaningVM {
  var meaningVC: IMeaningVC? { get set }
  var imageUrl: URL? { get }
  
  func fetchMeanings()
}

class MeaningVM: IMeaningVM {
  private let meaning: Meaning
  private let networkManager: INetworkManager
  
  weak var meaningVC: IMeaningVC?
  
  init(meaning: Meaning, networkManager: INetworkManager) {
    self.meaning = meaning
    self.networkManager = networkManager
  }
  
  var imageUrl: URL? {
    URL(string: "https:\(meaning.imageUrl)")
  }
  
  func fetchMeanings() {
    networkManager.meanings([meaning.id], from: Date()) { (result) in
      switch result {
      case .success(let meanings):
        guard let fullMeaning = meanings.first else {
          self.meaningVC?.showEmpty()
          return
        }
        self.meaningVC?.showMeaning(fullMeaning)
      case .failure(let error):
        self.meaningVC?.showError(error.localizedDescription)
      }
    }
  }
}
