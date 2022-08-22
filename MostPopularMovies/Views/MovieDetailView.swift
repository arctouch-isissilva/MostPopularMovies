//
//  MovieDetailView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieDetailView: View {

  let movieId: Int
  @ObservedObject private var viewModel = MovieDetailViewModel()

  var body: some View {
    ZStack {
      ProgressView()
      if viewModel.movie != nil {
        MovieDetailCardView(movie: viewModel.movie!)
      }
    }
    .onAppear {
      viewModel.loadMovie(id: movieId)
    }
    .errorAlert(error: $viewModel.error)
  }
}

private struct MovieDetailCardView: View {

  let movie: Movie

  var body: some View {
    ZStack(alignment: .top) {
      RoundedRectangle(cornerRadius: 20, style: .circular)
        .foregroundColor(Color("CardColor"))
      VStack(alignment: .leading) {
        AsyncImage(url: movie.backdropURL) { image in
          image.resizable()
        } placeholder: {
          ProgressView()
        }
        .aspectRatio(contentMode: .fit)
        .cornerRadius(20)
        Spacer()
        AvenirText(text: movie.title, textSize: 24)
          .padding(.horizontal, 8)
          .lineLimit(2)
        ScrollView {
          VStack {
            InfoTextView(infoText: "Score:", dataText: movie.popularityText)
            InfoTextView(infoText: "Release:", dataText: movie.yearText)
            InfoTextView(infoText: "Duration time:", dataText: movie.durationText)
            Spacer()
            Text(movie.overview ?? "")
              .font(.custom("Avenir Heavy", size: 14))
              .foregroundColor(.white)
              .padding(8)
            Spacer()
          }
          .padding(8)
        }
        GenreChipCarouselView(genres: movie.getGenresFromDetails())
      }
    }
    .padding(24)
  }
}
