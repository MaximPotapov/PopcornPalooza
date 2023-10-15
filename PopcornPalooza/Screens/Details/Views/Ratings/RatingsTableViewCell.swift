//
//  RatingsTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit

protocol RatingsTableViewCellDelegate: AnyObject {
  func openPlayer(with urlString: String?)
}

class RatingsTableViewCell: UITableViewCell {
  weak var delegate: RatingsTableViewCellDelegate?
  private var movie = MovieDetails.mockMovieDetails()
  
  @IBOutlet weak var totalVotesLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var trailerButton: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(with movie: MovieDetails) {
    self.movie = movie
    self.totalVotesLabel.text = String(movie.voteCount)
    self.ratingLabel.text = String(movie.voteAverage)
  }
  
  @IBAction func trailerTapped(_ sender: Any) {
      delegate?.openPlayer(with: "WwAUIwb04c4")
  }
}
