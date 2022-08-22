//
//  MovieService.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import Foundation

protocol MovieService {
  static func fetchPopularMovies(with currentPage: Int) async throws -> PopularMoviesResponse
  static func fetchMovieDetails(id: Int) async throws -> Movie
  static func fetchGenresList() async throws -> Genres
}

enum MovieServiceImplementation: MovieService {

  static func fetchMovieDetails(id: Int) async throws -> Movie {
    guard let url = URL(string: "\(APIContants.baseAPIURL)/movie/\(id)?api_key=\(APIContants.apiKey)") else {
      throw MovieError.failedEndpoint
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try  Utils.jsonDecoder.decode(Movie.self, from: data)
  }
  
  static func fetchPopularMovies(with currentPage: Int) async throws -> PopularMoviesResponse {
    guard let url = URL(string: "\(APIContants.baseAPIURL)/movie/popular?api_key=\(APIContants.apiKey)&page=\(currentPage)") else {
      throw MovieError.failedEndpoint
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try  Utils.jsonDecoder.decode(PopularMoviesResponse.self, from: data)
  }
 
  static func fetchGenresList() async throws -> Genres {
    guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIContants.apiKey)") else {
      throw MovieError.failedEndpoint
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try  Utils.jsonDecoder.decode(Genres.self, from: data)
  }
}

enum MovieError: Error {
  case failedEndpoint
  case failedFetchingMovies
  case failedFetchingGenres
  
  var title: String {
    switch self {
    case .failedEndpoint:
      return "Error"
    default:
      return "Something whent wrong!"
    }
  }
  
  var description: String {
    switch self {
    case .failedEndpoint:
      return "Endpoint failed"
    case .failedFetchingMovies:
      return "Failed fetching movies"
    case .failedFetchingGenres:
      return "Failed fetchin genres"
    }
  }
}

enum Utils {
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
}
