//
//  TranslateVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import SnapKit

class TranslateVC: UIViewController {
  private let networkManager: INetworkManager
  private var wordsTable: UITableView!
  
  private var words: [Word] = [] {
    didSet {
      wordsTable.reloadData()
    }
  }
  
  init(_ networkManager: INetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    fetchWords("слово")
  }
  
  private func setupViews() {
    wordsTable = UITableView()
    wordsTable.dataSource = self
    wordsTable.register(WordsTVC.self, forCellReuseIdentifier: WordsTVC.reuseID)
    view.addSubview(wordsTable)
    wordsTable.snp.makeConstraints { (maker) in
      maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      maker.leading.trailing.equalToSuperview()
    }
  }
  
  private func fetchWords(_ search: String) {
    networkManager.words(search, page: nil, pageSize: nil) { (result) in
      switch result {
      case .success(let words):
        self.words = words
        print(words)
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension TranslateVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    words.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WordsTVC.reuseID) as? WordsTVC else {
      fatalError()
    }
    
    cell.onBind(words[indexPath.item])
    
    return cell
  }
}
