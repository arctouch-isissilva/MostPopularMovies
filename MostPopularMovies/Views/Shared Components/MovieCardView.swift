//
//  MovieCardView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import SwiftUI

struct MovieCardView: View {
  
  let movie: MovieEntity
  let isDetailCard: Bool
  @State private var orientation = UIDevice.current.orientation
  
  var body: some View {
    
    ZStack(alignment: .top) {
      RoundedRectangle(cornerRadius: 20, style: .circular)
        .foregroundColor(Color("CardColor"))
     
      if orientation.isPortrait && isDetailCard {
        VStack {
          movieImageView
          movieDetailsView
        }
      } else {
        HStack {
          movieImageView
          movieDetailsView
        }
      }
    }
    .padding()
    .onRotate { newOrientation in
      orientation = newOrientation
    }
  }
  
  private var movieImageView: some View {
    AsyncImage(url: (isDetailCard && orientation.isPortrait) ? movie.backdropURL : movie.posterURL) { loadPhase in
      switch loadPhase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(20)
          .frame(maxWidth: .infinity, alignment: .center)
      default:
        ZStack {
          RoundedRectangle(cornerRadius: 20, style: .circular)
            .frame(width: 100, height: 100)
          ProgressView()
        }
      }
    }
  }
  
  private var movieDetailsView: some View {
    VStack(alignment: .leading) {
      AvenirText(text: movie.title, textSize: 22, fontType: .headline)
        .padding(8)
      InfoTextView(infoText: "Score:", dataText: movie.popularityText)
      InfoTextView(infoText: "Release:", dataText: movie.yearText)
      
      if isDetailCard {
        InfoTextView(infoText: "Duration time:", dataText: movie.durationText)
        Spacer()
        Text(movie.overview ?? "")
          .font(.custom("Avenir Heavy", size: 14))
          .foregroundColor(.white)
          .padding(8)
        
        if let url = URL(string: movie.homepage ?? "") {
          Link("Movie homepage", destination: url)
            .font(.custom("Avenir Heavy", size: 18))
            .font(.callout)
            .foregroundColor(Color("ChipColor"))
            .padding(8)
        }
      }
      GenreChipCarouselView(genres: PersistenceManager.shared.getGenres(ids: movie.genresIds))
    }
  }
}
