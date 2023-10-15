//
//  AFNetworkManager.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import Alamofire

final class AFNetworkManager {
  // MARK: - Properties
  static let shared = AFNetworkManager()
  private let baseUrl = TMDBAPI.baseUrl
}


// MARK: - Movie
extension AFNetworkManager {
  func getPopularMovies(paging: Bool, page: Int, lang: String = "en-US", completion: @escaping (Result<MovieResponse, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      return
    }
    
    let url = baseUrl + TMDBAPI.getPopularMovies + "?language=\(lang)&page=\(page)"
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: MovieResponse.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Movies: fetched \(data.results.count) popular movies")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription + "\n" + "\(response)")
            completion(.failure(error))
        }
      }
  }
  
  func getTopRatedMovies(paging: Bool, page: Int, lang: String = "en-US", completion: @escaping (Result<MovieResponse, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      //      completion(.failure())
      return
    }
    
    let url = baseUrl + TMDBAPI.getTopRatedMovies + "?language=\(lang)&page=\(page)"
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: MovieResponse.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Movies: fetched \(data.results.count) popular movies")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription + "\n" + "\(response)")
            completion(.failure(error))
        }
      }
  }
  
  func getNowPlayingMovies(paging: Bool, page: Int, lang: String = "en-US", completion: @escaping (Result<MovieResponse, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      //      completion(.failure())
      return
    }
    
    let url = baseUrl + TMDBAPI.getNowPlayingMovies + "?language=\(lang)&page=\(page)"
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: MovieResponse.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Movies: fetched \(data.results.count) now playing movies")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription + "\n" + "\(response)")
            completion(.failure(error))
        }
      }
  }
  
  func getUpcomingMovies(paging: Bool, page: Int, lang: String = "en-US", completion: @escaping (Result<MovieResponse, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      //      completion(.failure())
      return
    }
    
    let url = baseUrl + TMDBAPI.getUpcomingMovies + "?language=\(lang)&page=\(page)"
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: MovieResponse.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Movies: fetched \(data.results.count) upcoming movies")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription + "\n" + "\(response)")
            completion(.failure(error))
        }
      }
  }
}

// MARK: - Genre
extension AFNetworkManager {
  func fetchMovieGenres(completion: @escaping (Result<GenreResponse, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      //      completion(.failure())
      return
    }
    
    let url = baseUrl + TMDBAPI.getGenreTypes
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: GenreResponse.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Movies: fetched \(data.genres.count) genres")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription + "\n" + "\(response)")
            completion(.failure(error))
        }
      }
  }
}

// MARK: - Details
extension AFNetworkManager {
  func fetchMovieDetails(with id: Int, completion: @escaping(Result<MovieDetails, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      //      completion(.failure())
      return
    }
    
    let url = baseUrl + TMDBAPI.movieDetails + String(id)
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate().responseDecodable(of: MovieDetails.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Fetched \(data.title) details.")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription)
            completion(.failure(error))
        }
      }
  }
  
  func fetchMovieVideoSources(movie id: Int, completion: @escaping (Result<VideoResult, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
      //      completion(.failure())
      return
    }
    
    let url = baseUrl + TMDBAPI.movieDetails + String(id) + "/videos"
    
    let headers: HTTPHeaders = [
      .authorization("Bearer \(authToken)"),
      .accept("application/json")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate().responseDecodable(of: VideoResult.self) { response in
        switch response.result {
          case .success(let data):
            log.debug("Fetched \(data.results.count) video sources.")
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription)
            completion(.failure(error))
        }
      }
  }
}
