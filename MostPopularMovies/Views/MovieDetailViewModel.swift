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
  @Published var movieEntity: MovieEntity?
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
        let movie = try await movieService.fetchMovieDetails(id: id)
        PersistenceManager.shared.updateDataToCoreData(movie: movie)
        movieEntity = PersistenceManager.shared.getMovie(by: movieId)
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
}
