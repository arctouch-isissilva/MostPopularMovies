//
//  MoviesMock.swift
//  MostPopularMoviesTests
//
//  Created by Isis Silva on 24/08/22.
//

import Foundation

@testable import MostPopularMovies

extension Movie {
 static let pray = Movie(
    id: 766507,
    title: "Prey",
    backdropPath: "/p1F51Lvj3sMopG948F5HsBbl43C.jpg",
    posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
    overview: "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor Odinson enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Relatively Mighty Girl Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
    voteAverage: 6.8,
    runtime: 800,
    releaseDate: nil,
    genreIds: [28, 12, 14],
    genres: nil,
    homepage: nil
 )
}

extension PopularMoviesResponse {
  static let movieResponseMock = PopularMoviesResponse(
    page: 1,
    results: [.pray],
    totalPages: 5
  )
}

extension Genres {
  static let genresListMock = Genres(genres: [action, adventure, animation, comedy, crime, fantasy])
  static let action = Genre(id: 28, name: "Action")
  static let adventure = Genre(id: 12, name: "Adventure")
  static let animation = Genre(id: 16, name: "Animation")
  static let comedy = Genre(id: 35, name: "Comedy")
  static let crime = Genre(id: 80, name: "Crime")
  static let fantasy = Genre(id: 14, name: "Fantasy")
}
