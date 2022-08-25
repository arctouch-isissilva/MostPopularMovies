//
//  MovieDetailViewModel.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

@MainActor
final class MovieDetailViewModel: ObservableObject {

  let movieId: Int
  private let movieService: MovieService
  @Published var movie: Movie?
  @Published var isLoading = false
  @Published var error: MovieError? = nil
  
  init(movieId: Int, movieService: MovieService = MovieServiceImplementation()) {
    self.movieService = movieService
    self.movieId = movieId
  }

  func loadMovie(id: Int) {
    isLoading = true
    defer { isLoading = false }
    
    Task {
      do {
        movie = try await movieService.fetchMovieDetails(id: id)
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
}
