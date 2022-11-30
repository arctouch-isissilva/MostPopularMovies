//
//  MovieEntity+CoreDataProperties.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/09/22.
//
//

import Foundation
import CoreData

extension MovieEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
    return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
  }
  
  @NSManaged public var title: String
  @NSManaged public var id: Int
  @NSManaged public var backdropPath: String?
  @NSManaged public var posterPath: String?
  @NSManaged public var overview: String?
  @NSManaged public var voteAverage: Double
  @NSManaged public var runtime: Int
  @NSManaged public var releaseDate: String?
  @NSManaged public var homepage: String?
  @NSManaged public var genresIds: [Int]
  @NSManaged public var genres: NSSet?
  
  var genresArray: [GenreEntity] {
    let set = genres as? Set<GenreEntity> ?? []
    return set.map { $0 }
  }
  
  var popularityText: String {
    return String(format: "%.1f", voteAverage)
  }
  
  var durationText: String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute]
    return formatter.string(from: TimeInterval(runtime) * 60) ?? "-"
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

extension MovieEntity : Identifiable {}
