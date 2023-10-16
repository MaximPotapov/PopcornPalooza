//
//  NoInternetTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit

class NoInternetTableViewCell: UITableViewCell {
  // MARK: - Properties
  enum CellType {
    case network
    case data
    
    var imageName: String {
      switch self {
        case .data: return "noData"
        case .network: return "noWifi"
      }
    }
    
    var title: String {
      switch self {
        case .data: return "no_data".localized
        case .network: return "no_internet".localized
      }
    }
  }
  
  // MARK: - @IBOutlet's
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  // MARK: - Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 50, left: 0, bottom: -50, right: 0))
  }
  
  // MARK: - Public Methods
  func configure(with type: CellType) {
    iconImageView.image = UIImage(named: type.imageName)
    titleLabel.text = type.title
  }
}
