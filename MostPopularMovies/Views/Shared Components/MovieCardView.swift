//
//  MovieCardView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieCardView: View {
  let movie: Movie

  var body: some View {
    ZStack(alignment: .top) {
      RoundedRectangle(cornerRadius: 20, style: .circular)
        .foregroundColor(Color("CardColor"))
      VStack(alignment: .leading) {
        AsyncImage(url: movie.posterURL) { image in
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
        HStack {
          InfoTextView(infoText: "Score:", dataText: movie.popularityText)
          Spacer()
          InfoTextView(infoText: "Release:", dataText: movie.yearText)
        }
        .padding(8)
        GenreChipCarouselView(genres: movie.getGenres())
      }
    }
    .padding(24)
  }
}
