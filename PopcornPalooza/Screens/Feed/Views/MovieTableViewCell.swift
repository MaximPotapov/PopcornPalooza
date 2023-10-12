//
//  MovieTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  
  @IBOutlet weak var descriptionView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var ratingView: UIView!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
    self.clipsToBounds = true
    contentView.layer.cornerRadius = 16
    descriptionView.layer.cornerRadius = 16
    ratingView.layer.cornerRadius = 35
    ratingView.layer.borderWidth = 3
    ratingView.layer.borderColor = UIColor.white.cgColor
    }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0))
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
