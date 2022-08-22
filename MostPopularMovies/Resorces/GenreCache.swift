//
//  GenreCache.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import Foundation

final class GenreCash {
  
  static let shared = GenreCash()
  private var genreList: [Genre] = []
  
  var genres: [Genre] {
    return genreList
  }

  func saveGenreList(list: [Genre]) {
    genreList = list
  }

  func getGenreByIds(idList: [Int]) -> [String] {
    return genreList.filter { genre in
      idList.contains { genre.id == $0 }
    }.map { $0.name }
  }
}
