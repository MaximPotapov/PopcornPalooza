//
//  TMDBAPI.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import Foundation

struct TMDBAPI {
  static let baseUrl = "https://api.themoviedb.org/3/"
  static let getPopularMovies = "movie/popular"
  static let getTopRatedMovies = "movie/top_rated"
  static let getUpcomingMovies = "movie/upcoming"
  static let getNowPlayingMovies = "movie/now_playing"
  static let getGenreTypes = "genre/movie/list"
}
