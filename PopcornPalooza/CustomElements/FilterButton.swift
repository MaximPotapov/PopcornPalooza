//
//  FilterButton.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import UIKit

class FilterButton: UIBarButtonItem {
  convenience init(target: Any?, action: Selector, size: CGSize, name: String) {
        let backButtonImage = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        let resizedImage = backButtonImage?.resized(to: size)
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(resizedImage, for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: backButton)
    }
}
