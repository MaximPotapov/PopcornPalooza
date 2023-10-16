//
//  DescriptionTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    self.contentView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  func configure(with movie: MovieDetails) {
    descriptionLabel.text = movie.overview
  }
}
