//
//  PosterTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit

class PosterTableViewCell: UITableViewCell {

  @IBOutlet weak var posterImage: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(with movie: MovieDetails) {
    if let posterUrl = movie.posterPath {
      if let downloadUrl = URL(string: TMDBAPI.downloadImage + posterUrl) {
        self.posterImage.kf.setImage(with: downloadUrl)
      }
    }
  }
}
