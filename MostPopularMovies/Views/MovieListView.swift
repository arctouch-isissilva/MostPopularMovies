//
//  MovieListView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieListView: View {
  @StateObject private var viewModel = MovieListViewModel()
  
  var body: some View {
    let movies = viewModel.persistece.moviesEntity
    NavigationView {
      List(movies) { movie in
        NavigationLink {
          MovieDetailView(viewModel: MovieDetailViewModel(movieId: movie.id))
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
        let lastDay = UserDefaults.standard.object(forKey: "LastRun") as? Date ?? Date()
        if !Calendar.current.isDate(Date(), inSameDayAs: lastDay) {
          PersistenceManager.shared.deleteMovies()
          UserDefaults.standard.set(Date(), forKey:  "LastRun")
        }
        viewModel.loadGenres()
        if movies.isEmpty {
          viewModel.loadMovies()
        }
      }
      .errorAlert(error: $viewModel.error)
    }
    .phoneOnlyStackNavigationView()
  }
}
