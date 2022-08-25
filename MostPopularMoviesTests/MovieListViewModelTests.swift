//
//  MovieListViewModelTests.swift
//  MostPopularMoviesTests
//
//  Created by Isis Silva on 24/08/22.
//

import XCTest
@testable import MostPopularMovies

class MovieListViewModelTests: XCTestCase {
  
  private var viewModel: MovieListViewModel!
  private var moviesResponse: PopularMoviesResponse!
  
  override func setUp() async throws {
    try await super.setUp()
    moviesResponse = .movieResponseMock
    viewModel = await MovieListViewModel(movieService: MovieServiceMock())
  }
  
  override func tearDown() async throws {
    moviesResponse = nil
    viewModel = nil
    try await super.tearDown()
  }
  
  func testMovieList_isInitialEmpty() async throws {
    let moviePublisher = await viewModel.$movies.values.first { _ in true }!
    XCTAssertTrue(moviePublisher.isEmpty)
  }
  
  func testLoadMovieList_ReturnsFilledList_WhenLoadingMoviesList() async throws {
    let expectation = expectation(description: "Fetch movie by id")
    
    do {
      await viewModel.loadMovies()
      expectation.fulfill()
    }
    
    await waitForExpectations(timeout: 3)
    let moviePublisher = await viewModel.$movies.values.first { _ in true }!
    
    XCTAssertFalse(moviePublisher.isEmpty)
  }
  
  func testGenresList_MatchesMovieGenres_WhenLoadGenres() async throws {
    GenreCache.shared.clearGenreCash()
    let expectation = expectation(description: "Fetch genres list")
    
    do {
      await viewModel.loadGenresAndMoviesList()
      expectation.fulfill()
    }
    
    await waitForExpectations(timeout: 3)
    let moviesPublisher = await viewModel.$movies.values.first { _ in true }!
    let movieGenres = moviesPublisher.first?.getGenres()
    
    XCTAssertEqual(movieGenres, moviesResponse.results.first?.getGenres())
  }
}
