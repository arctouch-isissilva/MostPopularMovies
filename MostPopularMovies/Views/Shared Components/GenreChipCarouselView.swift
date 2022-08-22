//
//  GenreChipCarouselView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct GenreChipCarouselView: View {

  let genres: [String]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(genres, id: \.self) { genre in
          AvenirText(text: genre, textSize: 14)
            .padding(6)
            .background(Color("ChipColor"))
            .clipShape(Capsule())
        }
      }
    }
    .padding(.horizontal, 8)
    .padding(.bottom, 16)
  }
}
