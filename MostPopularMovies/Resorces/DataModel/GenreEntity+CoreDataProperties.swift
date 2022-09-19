//
//  GenreEntity+CoreDataProperties.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 18/09/22.
//
//

import Foundation
import CoreData

extension GenreEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreEntity> {
    return NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
  }
  
  @NSManaged public var id: Int
  @NSManaged public var name: String?
  @NSManaged public var movieGenres: MovieEntity?
}

extension GenreEntity : Identifiable {}
