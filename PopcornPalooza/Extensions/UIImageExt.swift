//
//  UIImageExt.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit

extension UIImage {
  func resized(to size: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}

extension UIImageView {
  func addShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: 2, height: 2)
    layer.shadowRadius = 5
    layer.masksToBounds = false
  }
}
