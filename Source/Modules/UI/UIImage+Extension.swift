//
//  UIImage+Extension.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/14/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

extension UIImage {
  func imageWithSize(size: CGSize) -> UIImage? {
    let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    UIColor.clear.set()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
