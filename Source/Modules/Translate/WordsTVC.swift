//
//  WordsTVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import Kingfisher

class WordsTVC: UITableViewCell {
  static let reuseID = "\(WordsTVC.self)"
  
  private var title: UILabel!
  private var wordImage: UIImageView!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    wordImage = UIImageView()
    wordImage.contentMode = .scaleAspectFill
    wordImage.clipsToBounds = true
    wordImage.backgroundColor = .systemGray3
    wordImage.layer.cornerRadius = 5
    contentView.addSubview(wordImage)
    wordImage.snp.makeConstraints { (maker) in
      maker.width.equalTo(60)
      maker.top.leading.bottom.equalToSuperview().inset(Constants.Offset.main)
    }
    
    title = UILabel()
    title.numberOfLines = 0
    contentView.addSubview(title)
    title.snp.makeConstraints { (maker) in
      maker.centerY.equalTo(wordImage.snp.centerY)
      maker.leading.equalTo(wordImage.snp.trailing).offset(Constants.Offset.spacing)
      maker.trailing.equalToSuperview().offset(-Constants.Offset.main)
    }
  }
  
  func onBind(_ meaning: Meaning) {
    title.text = meaning.translation.text
    wordImage.kf.setImage(with: URL(string: "https:\(meaning.previewUrl)"))
  }
}
