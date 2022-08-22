//
//  Genre.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import Foundation

struct Genre: Decodable {
  let id: Int
  let name: String
}

struct Genres: Decodable {
  let genres: [Genre]
}
