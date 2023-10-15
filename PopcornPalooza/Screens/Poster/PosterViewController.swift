//
//  PosterViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit
import Kingfisher

class PosterViewController: UIViewController {
  private var movie: MovieDetails
  private var scale: CGFloat = 1.0
  
  @IBOutlet weak var posterImageView: UIImageView!
  
  init(movie: MovieDetails) {
    self.movie = movie
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let posterUrl = movie.posterPath {
      if let downloadUrl = URL(string: TMDBAPI.downloadImage + posterUrl) {
        self.posterImageView.kf.setImage(with: downloadUrl)
      }
    }
    
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
    posterImageView.addGestureRecognizer(pinchGesture)
  }
  
  @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
      if gesture.state == .changed {
          let currentScale = scale * gesture.scale
        posterImageView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
      } else if gesture.state == .ended {
          // Update the scale value
          scale = posterImageView.transform.a
      }
  }
}
