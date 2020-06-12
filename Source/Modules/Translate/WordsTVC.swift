//
//  WordsTVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class WordsTVC: UITableViewCell {
  static let reuseID = "\(WordsTVC.self)"
  
  private var title: UILabel!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    title = UILabel()
    contentView.addSubview(title)
    title.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview().inset(16)
    }
  }
  
  func onBind(_ word: Word) {
    title.text = word.text
  }
}
