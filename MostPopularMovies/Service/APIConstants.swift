//
//  APIConstants.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/08/22.
//

import Foundation

enum APIContants {
  static let baseAPIURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
  static let baseImageURL = ProcessInfo.processInfo.environment["BASE_IMAGE_URL"] ?? ""
  static let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
}
