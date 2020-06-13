//
//  MeaningVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import Kingfisher
import ShimmerSwift

protocol IMeaningVC: class {
  func showMeaning(_ fullMeaning: FullMeaning)
}

class MeaningVC: ScrollVC {
  private let viewModel: IMeaningVM
  
  private var shimmeringImage: ShimmeringView!
  private var image: UIImageView!
  private var translation: UILabel!
  private var definition: UILabel!
  private var text: UILabel!
  private var transcription: UILabel!
  private var examplesStack: UIStackView!
  
  private let imageHeight: CGFloat = 300
  
  init(_ viewModel: IMeaningVM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    viewModel.fetchMeanings()
  }
  
  override func setupContentView(_ contentView: UIView) {
    shimmeringImage = ShimmeringView()
    
    contentView.addSubview(shimmeringImage)
    shimmeringImage.snp.makeConstraints { (maker) in
      maker.top.leading.trailing.equalToSuperview()
      maker.height.equalTo(imageHeight)
    }
    
    image = UIImageView()
    image.backgroundColor = .systemGray3
    image.contentMode = .scaleAspectFill
    image.clipsToBounds = true
    contentView.addSubview(image)
    image.snp.makeConstraints { (maker) in
      maker.top.leading.trailing.equalToSuperview()
      maker.height.equalTo(imageHeight)
    }
    
    shimmeringImage.contentView = image
    
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
    shimmeringImage.isShimmering = true
    image.kf.setImage(with: viewModel.imageUrl) { (_) in
      self.shimmeringImage.isShimmering = false
    }
  }
  
  private func getExampleLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = Constants.Fonts.T2
    label.text = text
    label.textColor = .systemGray3
    return label
  }
}

extension MeaningVC: IMeaningVC {
  func showMeaning(_ fullMeaning: FullMeaning) {
    text.text = fullMeaning.text
    transcription.text = "[\(fullMeaning.transcription)]"
    translation.text = fullMeaning.translation.text
    definition.text = fullMeaning.definition.text
    fullMeaning.examples.forEach { (example) in
      examplesStack.addArrangedSubview(getExampleLabel(example.text))
    }
  }
}

extension MeaningVC {
  static func instance(_ meaning: Meaning) -> MeaningVC {
    let vm = MeaningVM(meaning: meaning, networkManager: NetworkManager())
    let vc = MeaningVC(vm)
    vm.meaningVC = vc
    return vc
  }
}
