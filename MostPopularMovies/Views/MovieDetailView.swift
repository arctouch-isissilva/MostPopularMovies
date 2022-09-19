//
//  MovieDetailView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieDetailView: View {
  
  @StateObject var viewModel: MovieDetailViewModel
  
  var body: some View {
    movieDetailCardView
      .onAppear {
        viewModel.loadMovie(id: viewModel.movieId)
      }
      .errorAlert(error: $viewModel.error)
  }
  
  @ViewBuilder
  private var movieDetailCardView: some View {
    if let movie = viewModel.movieEntity {
      ScrollView {
        MovieCardView(movie: movie, isDetailCard: true)
      }
    } else {
      ProgressView()
    }
  }
}
