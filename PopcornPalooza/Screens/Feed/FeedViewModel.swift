//
//  FeedViewModel.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import Foundation

class FeedViewModel {
  enum DataSource {
    case popular
    case topRated
    case nowPlaying
    case upcoming
    case searched
  }
  
  var dataSource: DataSource = .popular
  
  var currentDataSource: [Movie] {
      switch dataSource {
      case .popular: return popularMovies
      case .topRated: return toRatedMovies
      case .nowPlaying: return nowPlayingMovies
      case .upcoming: return upcomingMovies
      case .searched: return searchFilteredMovies
      }
  }
  
  var searchFilteredMovies: [Movie] = []
  var movieGenres: [Genre] = []
  var selectedMoviewGenres: [Int] = LocalStorageManager.shared.getGenreFilters()
  
  private var originalDataSource: DataSource = .popular
  private var popularMovies: [Movie] = []
  private var toRatedMovies: [Movie] = []
  private var nowPlayingMovies: [Movie] = []
  private var upcomingMovies: [Movie] = []
  
  func updateDataSource(with dataSource: DataSource, completion: @escaping () -> Void) {
    self.dataSource = dataSource
    log.debug("Current data source: \(dataSource) with \(currentDataSource.count) elements")
    completion()
  }
  
  func dataSource(for selectedIndex: Int) -> DataSource? {
    switch selectedIndex {
      case 0: return .popular
      case 1: return .topRated
      case 2: return .nowPlaying
      case 3: return .upcoming
      default: return nil
    }
  }
  
  func saveOriginalDataSource() {
    originalDataSource = dataSource
  }
  
  func revertToOriginalDataSource(completion: @escaping () -> Void) {
    dataSource = originalDataSource
    log.debug("Reverted to original data source: \(originalDataSource) with \(currentDataSource.count) elements")
    completion()
  }
  
  func returnFilteredByGenresDataSource() -> [Movie] {
    let filters = LocalStorageManager.shared.getGenreFilters()
    return currentDataSource.filter { movie in
      let commonIds = Set(movie.genreIds).intersection(filters)
      return !commonIds.isEmpty
    }
  }
}

// MARK: - Movies
extension FeedViewModel {
  func fetchPopularMovies(completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getPopularMovies(page: 1, completion: { result in
      switch result {
        case .success(let movies):
          self.popularMovies = movies.results
          completion(true)
        case .failure(let error):
          completion(false)
          log.error("")
      }
    })
  }
  
   func fetchTopRatedMovies(completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getTopRatedMovies(page: 1, completion: { result in
      switch result {
        case .success(let movies):
          self.toRatedMovies = movies.results
          completion(true)
        case .failure(let error):
          completion(false)
          log.error("")
      }
    })
  }
  
  func fetchNowPlayingMovies(completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getNowPlayingMovies(page: 1, completion: { result in
      switch result {
        case .success(let movies):
          self.nowPlayingMovies = movies.results
          completion(true)
        case .failure(let error):
          completion(false)
          log.error("")
      }
    })
  }
  
  func fetchUpcomingMovies(completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getUpcomingMovies(page: 1, completion: { result in
      switch result {
        case .success(let movies):
          self.upcomingMovies = movies.results
          completion(true)
        case .failure(let error):
          completion(false)
          log.error("")
      }
    })
  }
}

// MARK: - Genres
extension FeedViewModel {
  func fetchMovieGenres() {
    AFNetworkManager.shared.fetchMovieGenres(completion: { result in
      switch result {
        case .success(let success):
          self.movieGenres = success.genres
        case .failure(let failure):
          log.error("")
      }
    })
  }
}
