//
//  MeaningVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import Kingfisher

class MeaningVC: ScrollVC {
  private let meaning: Meaning
  private let networkManager: INetworkManager
  
  private var image: UIImageView!
  private var translation: UILabel!
  private var definition: UILabel!
  private var text: UILabel!
  private var transcription: UILabel!
  private var examplesStack: UIStackView!
  
  private let imageHeight: CGFloat = 300
  
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
    setupViews()
    fetchWordMeanings()
  }
  
  override func setupContentView(_ contentView: UIView) {
    image = UIImageView()
    image.contentMode = .scaleAspectFill
    contentView.addSubview(image)
    image.snp.makeConstraints { (maker) in
      maker.top.leading.trailing.equalToSuperview()
      maker.height.equalTo(imageHeight)
    }
    
    text = UILabel()
    text.font = Constants.Fonts.T1
    text.numberOfLines = 0
    text.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    contentView.addSubview(text)
    text.snp.makeConstraints { (maker) in
      maker.top.equalTo(image.snp.bottom).offset(Constants.Offset.spacing)
      maker.leading.equalToSuperview().offset(Constants.Offset.main)
    }
    
    transcription = UILabel()
    text.font = Constants.Fonts.T1
    contentView.addSubview(transcription)
    transcription.snp.makeConstraints { (maker) in
      maker.centerY.equalTo(text.snp.centerY)
      maker.leading.equalTo(text.snp.trailing).offset(Constants.Offset.small)
      maker.trailing.equalToSuperview().offset(-Constants.Offset.main)
    }
    
    translation = UILabel()
    translation.font = Constants.Fonts.T1
    translation.numberOfLines = 0
    contentView.addSubview(translation)
    translation.snp.makeConstraints { (maker) in
      maker.top.equalTo(text.snp.bottom).offset(Constants.Offset.spacing)
      maker.leading.trailing.equalToSuperview().inset(Constants.Offset.main)
    }
    
    definition = UILabel()
    definition.font = Constants.Fonts.T2
    definition.numberOfLines = 0
    contentView.addSubview(definition)
    definition.snp.makeConstraints { (maker) in
      maker.top.equalTo(translation.snp.bottom).offset(Constants.Offset.spacing)
      maker.leading.trailing.equalToSuperview().inset(Constants.Offset.main)
    }
    
    examplesStack = UIStackView()
    examplesStack.spacing = Constants.Offset.small
    examplesStack.axis = .vertical
    contentView.addSubview(examplesStack)
    examplesStack.snp.makeConstraints { (maker) in
      maker.top.equalTo(definition.snp.bottom).offset(Constants.Offset.spacing)
      maker.leading.trailing.bottom.equalToSuperview().inset(Constants.Offset.main)
    }
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    navigationItem.largeTitleDisplayMode = .never
    image.kf.setImage(with: URL(string: "https:\(meaning.imageUrl)"))
  }
  
  private func getExampleLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = Constants.Fonts.T2
    label.text = text
    label.textColor = .systemGray3
    return label
  }
  
  private func fetchWordMeanings() {
    networkManager.meanings([meaning.id], from: Date()) { (result) in
      switch result {
      case .success(let meanings):
        self.onFetchMeanings(meanings)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func onFetchMeanings(_ meanings: [FullMeaning]) {
    guard let fullMeaning = meanings.first else {
      return
    }
    
    text.text = fullMeaning.text
    transcription.text = "[\(fullMeaning.transcription)]"
    translation.text = fullMeaning.translation.text
    definition.text = fullMeaning.definition.text
    fullMeaning.examples.forEach { (example) in
      examplesStack.addArrangedSubview(getExampleLabel(example.text))
    }
  }
}
