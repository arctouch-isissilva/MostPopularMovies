//
//  MovieListView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieListView: View {

  @StateObject private var viewModel = MovieListViewModel()
  @FetchRequest(sortDescriptors: [SortDescriptor(\.voteAverage, order: .reverse)]) var movies: FetchedResults<MovieEntity>
  
  var body: some View {
    NavigationView {
      List(movies) { movie in
        NavigationLink {
          MovieDetailView(viewModel: MovieDetailViewModel(movie: movie))
        } label: {
          if !movies.isEmpty && !viewModel.isLoading {
            MovieCardView(movie: movie, isDetailCard: false)
              .frame(maxWidth: .infinity, alignment: .center)
              .onAppear {
                if movie.id == movies.last?.id {
                  viewModel.loadMovies()
                }
              }
          } else {
            ProgressView()
          }
        }
        .listRowBackground(Color.clear)
      }
      .navigationTitle("Most Popular")
      .buttonStyle(.borderless)
      .listStyle(.inset)
      .foregroundColor(.clear)
      .onAppear {
        viewModel.loadGenresAndMoviesList()
        if movies.isEmpty {
          viewModel.loadMovies()
        }
      }
      .errorAlert(error: $viewModel.error)
    }
    .phoneOnlyStackNavigationView()
  }
}
