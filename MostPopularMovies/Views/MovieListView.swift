//
//  MovieListView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieListView: View {
  @ObservedObject private var viewModel = MovieListViewModel()
  
  var body: some View {
    NavigationView {
      List {
        if (viewModel.movies != nil) && (viewModel.isLoading == false) {
          ForEach(viewModel.movies ?? [], id: \.self) { movie in
            MovieCardView(movie: movie)
              .background(NavigationLink("", destination: MovieDetailView(movieId: movie.id)))
              .onAppear {
                if movie.id == viewModel.movies?.last?.id {
                  viewModel.loadMore()
                }
              }
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .listRowSeparator(/*@START_MENU_TOKEN@*/.hidden/*@END_MENU_TOKEN@*/)
          
        } else {
          ProgressView()
        }
      }
      .navigationTitle("Most Popular")
      .buttonStyle(.borderless)
      .listRowBackground(Color.clear)
      .listStyle(.inset)
      .foregroundColor(.clear)
      .onAppear {
        viewModel.loadGenresList()
      }
      .errorAlert(error: $viewModel.error)
    }
  }
}
