//
//  MeaningVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class MeaningVC: ScrollVC {
  private let meaning: Meaning
  private let networkManager: INetworkManager
  
  init(_ meaning: Meaning, networkManager: INetworkManager) {
    self.meaning = meaning
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchWordMeanings()
  }
  
  override func setupContentView(_ contentView: UIView) {
    
  }
  
  private func fetchWordMeanings() {
    networkManager.meanings([meaning.id], from: Date()) { (result) in
      switch result {
      case .success(let meanings):
        print(meanings)
      case .failure(let error):
        print(error)
      }
    }
  }
}
