//
//  DetailsTableViewCell.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    self.contentView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(with movie: MovieDetails) {
    let genreNames = movie.genres.map { $0.name }
    let genresString = genreNames.joined(separator: ", ")
    let prodCountries = movie.productionCountries.map { $0.name }
    let prodCountriesString = prodCountries.joined(separator: ", ")
    
    self.nameLabel.text = movie.title
    self.countryLabel.text = prodCountriesString
    self.yearLabel.text = movie.releaseDate.extractYearFromDateString()
    self.genresLabel.text = genresString
  }
}
