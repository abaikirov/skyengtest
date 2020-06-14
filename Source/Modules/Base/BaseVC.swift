//
//  BaseVC.swift
//  SkyEngTestTests
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
  func showErrorAlert(_ message: String) {
    let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak ac] (_) in
      ac?.dismiss(animated: true, completion: nil)
    }))
  }
}
