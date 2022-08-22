//
//  MovieListViewModel.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

@MainActor
final class MovieListViewModel: ObservableObject {

  @Published private var moviesResponse: PopularMoviesResponse?
  @Published var movies: [Movie]?
  @Published var isLoading: Bool = false
  @Published var error: MovieError?
  @Published var currentPage = 1
  private let movieService = MovieServiceImplementation.self

  func loadMovies(with currentPage: Int) {
    isLoading = true
    defer { isLoading = false}
    Task {
      do {
        moviesResponse = try await movieService.fetchPopularMovies(with: currentPage)
        movies = moviesResponse?.results
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }

  func loadGenresList() {
    guard GenreCash.shared.genres.isEmpty else { return }
    isLoading = true
    currentPage = 1
    defer { isLoading = false}
    Task {
      do {
        let genres = try await movieService.fetchGenresList().genres
        GenreCash.shared.saveGenreList(list: genres)
        loadMovies(with: currentPage)
      } catch {
        self.error = MovieError.failedFetchingGenres
      }
    }
  }

  func loadMore() {
    guard !isLoading, (currentPage < moviesResponse?.totalPages ?? 1) else { return }
    isLoading = true
    defer { isLoading = false}
    currentPage += 1
    Task {
      do {
        let moviesList = try await movieService.fetchPopularMovies(with: currentPage).results
        movies?.append(contentsOf: moviesList)
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
}
