//
//  UISearchBar+Extension.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

extension UISearchBar {
  public var activityIndicator: UIActivityIndicatorView? {
    return searchTextField.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
  }
  
  var isLoading: Bool {
    get {
      return activityIndicator != nil
    }
    set {
      if newValue {
        if activityIndicator == nil {
          let newActivityIndicator = UIActivityIndicatorView()
          newActivityIndicator.startAnimating()
          newActivityIndicator.backgroundColor = .systemGray
          searchTextField.leftView?.addSubview(newActivityIndicator)
          let leftViewSize = searchTextField.leftView?.frame.size ?? CGSize.zero
          newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
          setImage(UIImage().imageWithSize(size: leftViewSize), for: .search, state: .normal)
        }
      } else {
        activityIndicator?.removeFromSuperview()
        setImage(UIImage(named: "search"), for: .search, state: .normal)
      }
    }
  }
}
