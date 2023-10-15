//
//  MovieDetailsViewModel.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import Foundation

class MovieDetailsViewModel {
  var movie: MovieDetails = MovieDetails.mockMovieDetails()
  
  func fetchMovieDetails(movieId: Int, completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.fetchMovieDetails(with: movieId) { result in
      switch result {
        case .success(let success):
          self.movie = success
          completion(true)
        case .failure(let failure):
          log.error("")
          completion(false)
      }
    }
  }
  
  func fetchYouTubeVideoKey(completion: @escaping (String?) -> Void) {
    AFNetworkManager.shared.fetchMovieVideoSources(movie: movie.id) { result in
      switch result {
        case .success(let success):
          success.results.forEach {
            if $0.site == "YouTube" {
              completion($0.key)
            }
          }
        case .failure(let failure):
          completion(nil)
      }
    }
  }
}
