//
//  MovieDetailViewModelTests.swift
//  MostPopularMoviesTests
//
//  Created by Isis Silva on 24/08/22.
//

import XCTest
@testable import MostPopularMovies

class MovieDetailViewModelTests: XCTestCase {
  
  private var viewModel: MovieDetailViewModel!
  private var movie: Movie!
  private var movieId: Int!
  
  override func setUp() async throws {
    try await super.setUp()
    movieId = 0
    movie = .pray
    viewModel = await MovieDetailViewModel(movieId: movieId, movieService: MovieServiceMock())
  }
  
  override func tearDown() async throws {
    movieId = nil
    movie = nil
    viewModel = nil
    try await super.tearDown()
  }
  
  func testLoadMovie_ReturnsNil_WhenPassingWrongMovieId() async throws {
    let expectation = expectation(description: "Fetch movie by id")
    
    do {
      await viewModel.loadMovie(id: movieId)
      expectation.fulfill()
    }
    
    await waitForExpectations(timeout: 3)
    let moviePublisher = await viewModel.$movie.values.first { _ in true }
    let movieTitle = moviePublisher?.map { $0.title }
    
    XCTAssertNotEqual(movieTitle ?? "", movie.title)
  }
  
  func testLoadMovie_ReturnsExpectedMovie_WhenPassingMovieId() async throws {
    let expectation = expectation(description: "Fetch movie by id")
    
    do {
      await viewModel.loadMovie(id: movie.id)
      expectation.fulfill()
    }
    
    await waitForExpectations(timeout: 3)
    let moviePublisher = await viewModel.$movie.values.first { _ in true }
    let movieTitle = moviePublisher?.map { $0.title }
    
    XCTAssertEqual(movieTitle ?? "", movie.title)
  }
}
