//
//  MovieDetailViewModel.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

@MainActor
final class MovieDetailViewModel: ObservableObject {

  private let movieService = MovieServiceImplementation.self
  @Published var movie: Movie?
  @Published var isLoading = false
  @Published var error: MovieError? = nil
  
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
