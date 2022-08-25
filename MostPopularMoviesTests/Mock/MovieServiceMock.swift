//
//  MovieServiceMock.swift
//  MostPopularMoviesTests
//
//  Created by Isis Silva on 24/08/22.
//

import Foundation
import Combine

@testable import MostPopularMovies

struct MovieServiceMock: MovieService {
  
  func fetchPopularMovies(with currentPage: Int) async throws -> PopularMoviesResponse {
    return .movieResponseMock
  }
  
  func fetchGenresList() async throws -> Genres {
    return .genresListMock
  }
  
  func fetchMovieDetails(id: Int) async throws -> Movie {
    if Movie.pray.id == id {
      return .pray
    } else {
      throw MovieError.failedFetchingMovies
    }
  }
}
