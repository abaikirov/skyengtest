//
//  ScrollVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import SnapKit

class ScrollVC: UIViewController {
  private var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupKeyboardListener()
  }
  
  internal func setupContentView(_ contentView: UIView) { fatalError("Must implement in child") }
  
  private func setupViews() {
    scrollView = UIScrollView()
    scrollView.keyboardDismissMode = .onDrag
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { (maker) in
      if #available(iOS 11.0, *) {
        maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      } else {
        // Fallback on earlier versions
        maker.top.equalTo(topLayoutGuide.snp.bottom)
      }
      maker.bottom.leading.trailing.equalToSuperview()
    }
    
    let contentView = UIView()
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview()
      maker.width.equalTo(view.snp.width)
    }
    
    setupContentView(contentView)
  }
  
  private func setupKeyboardListener() {
    let center = NotificationCenter.default
    center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    let frame  = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
    scrollView.contentInset = contentInset
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    scrollView.contentInset = UIEdgeInsets.zero
  }
}

