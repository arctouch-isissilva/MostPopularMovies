//
//  PersistenceManager.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 16/09/22.
//

import CoreData
import Foundation

struct PersistenceManager {
  
  static let shared = PersistenceManager()
  let container: NSPersistentContainer = NSPersistentContainer(name: "MovieContainer")
  
  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func saveDataOf(movies: [Movie]) {
    container.performBackgroundTask { (context) in
      deleteDuplicated(movies: movies)
      saveDataToCoreData(movies: movies)
    }
  }
  
  func saveDataOf(genres: [Genre]) {
    container.performBackgroundTask { _ in
      deleteGenres()
      saveGenresToCoreData(genres: genres)
    }
  }
  
  private func deleteDuplicated(movies: [Movie]) {
    do {
      let objects = try container.viewContext.fetch(MovieEntity.fetchRequest())
        _ = objects.map { container.viewContext.delete($0) }
      try container.viewContext.save()
    } catch {
      print("Deleting Error: \(error)")
    }
  }
  
  private func deleteGenres() {
    do {
      let objects = try container.viewContext.fetch(GenreEntity.fetchRequest())
      _ = objects.map { container.viewContext.delete($0) }
      try container.viewContext.save()
    } catch {
      print("Deleting Error: \(error)")
    }
  }
  
  private func saveDataToCoreData(movies:[Movie]) {
    container.viewContext.perform {
      for movie in movies {
        let movieEntity: MovieEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: container.viewContext) as! MovieEntity
        movieEntity.id =  movie.id
        movieEntity.title = movie.title
        movieEntity.homepage = movie.homepage
        movieEntity.voteAverage = movie.voteAverage ?? 0
        movieEntity.posterPath = movie.posterPath
        movieEntity.backdropPath = movie.backdropPath
        movieEntity.overview = movie.overview
        movieEntity.runtime = movie.runtime ?? 0
        movieEntity.releaseDate = movie.releaseDate
        movieEntity.genresIds = movie.genreIds ?? []
      }
      do {
        try container.viewContext.save()
      } catch {
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  
  func updateDataToCoreData(movie: Movie) {
    container.viewContext.perform {
      let movieEntity: MovieEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: container.viewContext) as! MovieEntity
      movieEntity.homepage = movie.homepage
      movieEntity.voteAverage = movie.voteAverage ?? 0
      movieEntity.posterPath = movie.posterPath
      movieEntity.backdropPath = movie.backdropPath
      movieEntity.overview = movie.overview
      movieEntity.runtime = movie.runtime ?? 0
      movieEntity.releaseDate = movie.releaseDate
      movieEntity.genresIds = movie.genreIds ?? []
      do {
        try container.viewContext.save()
      } catch {
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  
  private func saveGenresToCoreData(genres: [Genre]) {
    container.viewContext.perform {
      for genre in genres {
        let genreEntity = GenreEntity(context: container.viewContext)
        genreEntity.id = genre.id
        genreEntity.name = genre.name
      }
      do {
        try container.viewContext.save()
      } catch {
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  
  func fetchGenresList() -> [GenreEntity] {
    var genres: [GenreEntity] = []
    do {
      genres = try container.viewContext.fetch(GenreEntity.fetchRequest())
    } catch {
      print(error)
    }
    return genres
  }
  
  func getGenres(ids: [Int]) -> [String] {
    return fetchGenresList().filter { genre in
      ids.contains { genre.id == $0 }
    }.map { $0.name ?? "" }
  }
  
  func getMovie(by id: Int) -> MovieEntity {
    var movies: [MovieEntity] = []
    do {
      movies = try container.viewContext.fetch(MovieEntity.fetchRequest())
    } catch {
      print(error)
    }
    return movies.filter { $0.id == id }.first!
  }
}
