//
//  EmptyView.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class EmptyView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    backgroundColor = .systemBackground
    
    let label = UILabel()
    label.text = "Nothing found"
    label.textAlignment = .center
    label.textColor = .systemGray5
    label.font = Constants.Fonts.big
    addSubview(label)
    label.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview()
    }
  }
}
