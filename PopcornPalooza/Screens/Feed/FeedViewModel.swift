//
//  FeedViewModel.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import Foundation

class FeedViewModel {
  // MARK: - Properties
  enum DataSource {
    case popular
    case topRated
    case nowPlaying
    case upcoming
    case searched
  }
  
  var dataSource: DataSource = .popular
  var currentPage: Int = 1
  var totalPages: Int = 5
  
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
  
  private var originalDataSource: DataSource = .popular
  private var popularMovies: [Movie] = []
  private var toRatedMovies: [Movie] = []
  private var nowPlayingMovies: [Movie] = []
  private var upcomingMovies: [Movie] = []
  
  // MARK: - Public Methods
  func updateDataSource(
    with dataSource: DataSource,
    completion: @escaping () -> Void) {
    self.dataSource = dataSource
    self.currentPage = 1
    log.debug("Current data source: \(dataSource) with \(currentDataSource.count) elements")
    completion()
  }
  
  func dataSource(
    for selectedIndex: Int)
  -> DataSource? {
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
  
  func revertToOriginalDataSource(
    completion: @escaping () -> Void)
  {
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
  func fetchPopularMovies(
    page: Int,
    pageSize: Int,
    completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getPopularMovies(
      page: page,
      pageSize: pageSize) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let movies):
          if page == 1 {
            self.popularMovies = movies.results
          } else {
            self.popularMovies.append(contentsOf: movies.results)
          }
          
          self.currentPage += 1
          completion(true)
        case .failure(let error):
          completion(false)
          log.error(error.localizedDescription)
      }
    }
  }
  
   func fetchTopRatedMovies(
    page: Int,
    pageSize: Int,
    completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getTopRatedMovies(
      page: page,
      pageSize: pageSize,
      completion: { result in
      switch result {
        case .success(let movies):
          self.toRatedMovies = movies.results
          completion(true)
        case .failure(_):
          completion(false)
          log.error("")
      }
    })
  }
  
  func fetchNowPlayingMovies(
    page: Int,
    pageSize: Int,
    completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getNowPlayingMovies(
      page: page,
      pageSize: pageSize,
      completion: { result in
      switch result {
        case .success(let movies):
          self.nowPlayingMovies = movies.results
          completion(true)
        case .failure(_):
          completion(false)
          log.error("")
      }
    })
  }
  
  func fetchUpcomingMovies(
    page: Int,
    pageSize: Int,
    completion: @escaping (Bool) -> Void) {
    AFNetworkManager.shared.getUpcomingMovies(
      page: page,
      pageSize: pageSize,
      completion: { result in
      switch result {
        case .success(let movies):
          self.upcomingMovies = movies.results
          completion(true)
        case .failure(_):
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
        case .failure(_):
          log.error("")
      }
    })
  }
}
