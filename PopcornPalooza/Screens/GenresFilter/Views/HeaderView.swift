//
//  HeaderView.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 17.10.2023.
//

import UIKit

class HeaderView: UIView {
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor = UIColor.black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.text = "filter_title".localized
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
