//
//  MovieListViewModel.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI
import CoreData

@MainActor
final class MovieListViewModel: ObservableObject {

  @Published var isLoading: Bool = false
  @Published var error: MovieError?
  @Published var currentPage = 0
  private let movieService: MovieService
  private var moviesResponse: PopularMoviesResponse?
  
  init(movieService: MovieService = MovieServiceImplementation()) {
    self.movieService = movieService
  }
  
  func loadGenres() {
    guard PersistenceManager.shared.fetchGenresList().isEmpty else { return }
    isLoading = true
    defer { isLoading = false }
    Task {
      do {
        let genres = try await movieService.fetchGenresList().genres
        PersistenceManager.shared.saveDataOf(genres: genres)
      } catch {
        self.error = MovieError.failedFetchingGenres
      }
    }
  }
  
  func loadMovies() {
    guard !isLoading, currentPage < moviesResponse?.totalPages ?? 1 else { return }
    isLoading = true
    defer { isLoading = false }
    currentPage += 1
    Task {
      do {
        moviesResponse = try await movieService.fetchPopularMovies(with: currentPage)
        PersistenceManager.shared.saveDataOf(movies: moviesResponse?.results ?? [])
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
}
