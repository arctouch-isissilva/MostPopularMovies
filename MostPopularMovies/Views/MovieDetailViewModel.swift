//
//  MovieDetailViewModel.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

@MainActor
final class MovieDetailViewModel: ObservableObject {
  
  private let movieService: MovieService
  private let movieId: Int
  @Published var movieEntity: MovieEntity?
  @Published var isLoading = false
  @Published var error: MovieError? = nil
  
  init(movieId: Int, movieService: MovieService = MovieServiceImplementation()) {
    self.movieService = movieService
    self.movieId = movieId
  }
  
  func loadMovie() {
    isLoading = true
    defer { isLoading = false }
    Task {
      do {
        let fetchedMovie = try await movieService.fetchMovieDetails(id: movieId)
        movieEntity = PersistenceManager.shared.updateDataToCoreData(movie: fetchedMovie)
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
}
