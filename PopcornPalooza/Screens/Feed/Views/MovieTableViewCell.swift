//
//  MovieTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
  // MARK: - @IBOutlet's
  @IBOutlet weak var descriptionView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var moviePosterImageView: UIImageView!
  
  // MARK: - Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    self.clipsToBounds = true
    contentView.layer.cornerRadius = 16
    descriptionView.layer.cornerRadius = 16
    moviePosterImageView.layer.cornerRadius = 16
    moviePosterImageView.addShadow()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Public Methods
  func configure(with movie: Movie, genres: [String]) {
    let genresString = genres.joined(separator: ", ")
    self.genresLabel.text = genresString
    self.nameLabel.text = movie.title
    self.yearLabel.text = movie.releaseDate.extractYearFromDateString()
    self.ratingLabel.text = String(movie.voteAverage)
    
    if let posterUrl = movie.posterPath {
      if let downloadUrl = URL(string: TMDBAPI.downloadImage + posterUrl) {
        self.moviePosterImageView.kf.setImage(with: downloadUrl)
      }
    }
  }
}
