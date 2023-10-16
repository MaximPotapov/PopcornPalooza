//
//  GenresTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import UIKit

class GenresTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var checkMarkImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(with title: String, selected: Bool = false) {
    self.titleLabel.text = title
    self.checkMarkImageView.isHidden = !selected
  }
}
