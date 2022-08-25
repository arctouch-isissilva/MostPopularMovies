//
//  MovieListViewModel.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

@MainActor
final class MovieListViewModel: ObservableObject {
  
  @Published var movies: [Movie] = []
  @Published var isLoading: Bool = false
  @Published var error: MovieError?
  @Published var currentPage = 0
  private let movieService: MovieService
  private var moviesResponse: PopularMoviesResponse?
  
  init(movieService: MovieService = MovieServiceImplementation()) {
    self.movieService = movieService
  }
  
  func loadGenresAndMoviesList() {
    guard GenreCache.shared.genres.isEmpty else { return }
    isLoading = true
    defer { isLoading = false }
    Task {
      do {
        let genres = try await movieService.fetchGenresList().genres
        GenreCache.shared.saveGenreList(list: genres)
        loadMovies()
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
        movies.isEmpty ? movies = moviesResponse?.results ?? [] : movies.append(contentsOf: moviesResponse?.results ?? [])
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
}
