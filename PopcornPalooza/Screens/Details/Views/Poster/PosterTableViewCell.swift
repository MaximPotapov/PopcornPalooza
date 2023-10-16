//
//  PosterTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit

protocol PosterTableViewCellDelegate: AnyObject {
  func openPlayer()
}

class PosterTableViewCell: UITableViewCell {
  weak var delegate: PosterTableViewCellDelegate?
  
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var trailerButton: UIButton!
  @IBOutlet weak var ratingLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    posterImage.layer.cornerRadius = 16
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
    
    self.ratingLabel.text = String(movie.voteAverage)
  }
  
  @IBAction func trailerButtonTapped(_ sender: UIButton) {
    delegate?.openPlayer()
  }
}
