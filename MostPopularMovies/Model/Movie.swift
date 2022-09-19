//
//  Movie.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 16/08/22.
//

import Foundation

struct PopularMoviesResponse: Decodable {
  let page: Int
  let results: [Movie]
  let totalPages: Int
}
   
struct Movie: Decodable {
  let id: Int
  let title: String
  let backdropPath: String?
  let posterPath: String?
  let overview: String?
  let voteAverage: Double?
  let runtime: Int?
  let releaseDate: String?
  let genreIds: [Int]?
  let genres: [Genre]?
  let homepage: String?
}

extension Movie: Identifiable, Hashable {
  static func == (lhs: Movie, rhs: Movie) -> Bool { lhs.id == rhs.id }
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
