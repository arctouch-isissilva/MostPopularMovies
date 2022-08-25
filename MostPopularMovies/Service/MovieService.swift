//
//  MovieService.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import Foundation

protocol MovieService {
  func fetchPopularMovies(with currentPage: Int) async throws -> PopularMoviesResponse
  func fetchMovieDetails(id: Int) async throws -> Movie
  func fetchGenresList() async throws -> Genres
}

struct MovieServiceImplementation: MovieService {

  func fetchMovieDetails(id: Int) async throws -> Movie {
    guard let url = URL(string: "\(APIContants.baseAPIURL)/movie/\(id)?api_key=\(APIContants.apiKey)") else {
      throw MovieError.failedEndpoint
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try  Utils.jsonDecoder.decode(Movie.self, from: data)
  }
  
  func fetchPopularMovies(with currentPage: Int) async throws -> PopularMoviesResponse {
    guard let url = URL(string: "\(APIContants.baseAPIURL)/movie/popular?api_key=\(APIContants.apiKey)&page=\(currentPage)") else {
      throw MovieError.failedEndpoint
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try  Utils.jsonDecoder.decode(PopularMoviesResponse.self, from: data)
  }
 
  func fetchGenresList() async throws -> Genres {
    guard let url = URL(string: "\(APIContants.baseAPIURL)/genre/movie/list?api_key=\(APIContants.apiKey)") else {
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
      return "Something went wrong!"
    }
  }
  
  var description: String {
    switch self {
    case .failedEndpoint:
      return "Endpoint failed"
    case .failedFetchingMovies:
      return "Failed fetching movies"
    case .failedFetchingGenres:
      return "Failed fetching genres"
    }
  }
}
