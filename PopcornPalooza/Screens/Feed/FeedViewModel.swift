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
  var isPaginating = false
  
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
    paging: Bool,
    completion: @escaping (Bool) -> Void) {
      if paging {
        self.isPaginating = true
      }
      
      AFNetworkManager.shared.getPopularMovies(
        paging: paging,
        page: currentPage) { [weak self] result in
          guard let self = self else { return }
          switch result {
            case .success(let movies):
              if !paging {
                self.popularMovies = movies.results
              } else {
                self.popularMovies.append(contentsOf: movies.results)
              }
              completion(true)
              
              if paging {
                self.currentPage += 1
                self.isPaginating = false
              }
            case .failure(let error):
              completion(false)
              log.error(error.localizedDescription)
          }
        }
    }
  
  func fetchTopRatedMovies(
    paging: Bool,
    completion: @escaping (Bool) -> Void) {
      if paging {
        self.isPaginating = true
      }
      
      AFNetworkManager.shared.getTopRatedMovies(
        paging: paging,
        page: currentPage) { [weak self] result in
          guard let self = self else { return }
          switch result {
            case .success(let movies):
              if !paging {
                self.toRatedMovies = movies.results
              } else {
                self.toRatedMovies.append(contentsOf: movies.results)
              }
              
              completion(true)
              
              if paging {
                self.currentPage += 1
                self.isPaginating = false
              }
            case .failure(_):
              completion(false)
              log.error("")
          }
        }
    }
  
  func fetchNowPlayingMovies(
    paging: Bool,
    completion: @escaping (Bool) -> Void) {
      if paging {
        self.isPaginating = true
      }
      
      AFNetworkManager.shared.getNowPlayingMovies(
        paging: paging,
        page: currentPage) { [weak self] result in
          guard let self = self else { return }
          switch result {
            case .success(let movies):
              if !paging {
                self.nowPlayingMovies = movies.results
              } else {
                self.nowPlayingMovies.append(contentsOf: movies.results)
              }
              
              completion(true)
              
              if paging {
                self.currentPage += 1
                self.isPaginating = false
              }
            case .failure(_):
              completion(false)
              log.error("")
          }
        }
    }
  
  func fetchUpcomingMovies(
    paging: Bool,
    completion: @escaping (Bool) -> Void) {
      if paging {
        self.isPaginating = true
      }
      
      AFNetworkManager.shared.getUpcomingMovies(
        paging: paging,
        page: currentPage) { [weak self] result in
          guard let self = self else { return }
          switch result {
            case .success(let movies):
              if !paging {
                self.upcomingMovies = movies.results
              } else {
                self.upcomingMovies.append(contentsOf: movies.results)
              }
              
              completion(true)
              
              if paging {
                self.currentPage += 1
                self.isPaginating = false
              }
            case .failure(_):
              completion(false)
              log.error("")
          }
        }
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
