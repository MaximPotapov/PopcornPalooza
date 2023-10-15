//
//  MovieDetails.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import Foundation

struct MovieDetails: Decodable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Collection: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
  }
}

struct ProductionCompany: Decodable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case logoPath = "logo_path"
    case name
    case originCountry = "origin_country"
  }
}

struct ProductionCountry: Decodable {
    let iso31661: String
    let name: String
  
  enum CodingKeys: String, CodingKey {
    case iso31661 = "iso_3166_1"
    case name
  }
}

struct SpokenLanguage: Decodable {
    let englishName: String
    let iso6391: String
    let name: String
  
  enum CodingKeys: String, CodingKey {
    case englishName = "english_name"
    case iso6391 = "iso_639_1"
    case name
  }
}

// MARK: - Mock
extension MovieDetails {
    static func mockMovieDetails() -> MovieDetails {
        return MovieDetails(
            adult: false,
            backdropPath: "/mock_backdrop_path.jpg",
            belongsToCollection: Collection(id: 1, name: "Mock Collection", posterPath: "/mock_collection_poster.jpg", backdropPath: "/mock_collection_backdrop.jpg"),
            budget: 100000000,
            genres: [
                Genre(id: 28, name: "Action"),
                Genre(id: 53, name: "Thriller")
            ],
            homepage: "https://www.example.com",
            id: 12345,
            imdbId: "tt1234567",
            originalLanguage: "en",
            originalTitle: "Mock Movie",
            overview: "This is a mock movie overview.",
            popularity: 123.45,
            posterPath: "/mock_poster_path.jpg",
            productionCompanies: [
                ProductionCompany(id: 1, logoPath: "/mock_logo.jpg", name: "Mock Company", originCountry: "US")
            ],
            productionCountries: [
                ProductionCountry(iso31661: "US", name: "United States of America")
            ],
            releaseDate: "2023-10-12",
            revenue: 50000000,
            runtime: 120,
            spokenLanguages: [
                SpokenLanguage(englishName: "English", iso6391: "en", name: "English")
            ],
            status: "Released",
            tagline: "A mock movie",
            title: "Mock Movie",
            video: false,
            voteAverage: 8.0,
            voteCount: 1000
        )
    }
}
