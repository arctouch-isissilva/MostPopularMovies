//
//  GenreCache.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import Foundation

final class GenreCache {
  
  static let shared = GenreCache()
  private var genreList: [Genre] = []
  
  var genres: [Genre] {
    return genreList
  }

  func saveGenreList(list: [Genre]) {
    genreList = list
  }

  func getGenresBy(_ indexes: [Int]) -> [String] {
    return genreList.filter { genre in
      indexes.contains { genre.id == $0 }
    }.map { $0.name }
  }
  
  func clearGenreCash() {
    genreList = []
  }
}
