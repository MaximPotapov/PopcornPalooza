//
//  GenresTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import UIKit

class GenresTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(with title: String) {
    self.titleLabel.text = title
  }
}
