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
  @Published var movieEntity: MovieEntity
  @Published var isLoading = false
  @Published var error: MovieError? = nil
  
  init(movie: MovieEntity, movieService: MovieService = MovieServiceImplementation()) {
    self.movieService = movieService
    self.movieEntity = movie
  }
  
  func loadMovie() {
    guard (movieEntity.overview == nil) else { return }
    isLoading = true
    defer { isLoading = false }
    Task {
      do {
        let fetchedMovie = try await movieService.fetchMovieDetails(id: movieEntity.id)
        await PersistenceManager.shared.updateDataToCoreData(movieEntity: movieEntity, movie: fetchedMovie)
        fetchUpdatedMovie()
      } catch {
        self.error = MovieError.failedFetchingMovies
      }
    }
  }
  
  private func fetchUpdatedMovie() {
    do {
      movieEntity = try PersistenceManager.shared.container.viewContext.fetch(MovieEntity.fetchRequest()).first(where: { $0.id == movieEntity.id}) ?? movieEntity
    } catch {
      print(error)
    }
  }
}
