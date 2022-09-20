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
        viewModel.loadMovie()
      }
      .errorAlert(error: $viewModel.error)
  }
  
  @ViewBuilder
  private var movieDetailCardView: some View {
    if (viewModel.movieEntity.overview != nil) {
      ScrollView {
        MovieCardView(movie: viewModel.movieEntity, isDetailCard: true)
      }
    } else {
      ProgressView()
    }
  }
}
