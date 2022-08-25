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
  
  var popularityText: String {
    return String(format: "%.1f", voteAverage ?? 0)
  }
  
  var durationText: String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute]
    return formatter.string(from: TimeInterval(runtime ?? 0) * 60) ?? "-"
  }
  
  var yearText: String {
    guard let releaseDate = releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else { return "-" }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: date)
  }
  
  var backdropURL: URL {
    guard let url = URL(string: APIContants.baseImageURL + (backdropPath ?? "")) else { fatalError() }
    return url
  }
  
  var posterURL: URL {
    guard let url = URL(string: APIContants.baseImageURL + (posterPath ?? "")) else { fatalError() }
    return url
  }
}

extension Movie {
  func getGenres() -> [String] {
    return GenreCache.shared.getGenresBy(genreIds ?? [])
  }
  
  func getGenresFromDetails() -> [String] {
    return GenreCache.shared.getGenresBy(genres?.map { $0.id } ?? [])
  }
}

extension Movie: Identifiable, Hashable {
  static func == (lhs: Movie, rhs: Movie) -> Bool { lhs.id == rhs.id }
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
