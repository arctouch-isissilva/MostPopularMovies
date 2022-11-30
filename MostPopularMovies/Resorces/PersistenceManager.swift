//
//  PersistenceManager.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 16/09/22.
//

import CoreData
import Foundation

class PersistenceManager: NSObject, ObservableObject {
  static let shared = PersistenceManager()
  let container: NSPersistentContainer = NSPersistentContainer(name: "MovieContainer")
  @Published var moviesEntity: [MovieEntity] = []
  private let controller: NSFetchedResultsController<MovieEntity>

  override init() {
    controller = NSFetchedResultsController(fetchRequest: MovieEntity.movieFetchRequest,
                                            managedObjectContext: container.viewContext,
                                            sectionNameKeyPath: nil, cacheName: nil)
    super.init()
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
        return
      }
    }
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    
    controller.delegate = self
    do {
      try controller.performFetch()
      moviesEntity = controller.fetchedObjects ?? []
    } catch {
      print("Failed fetch")
    }
  }
  
  func saveDataOf(movies: [Movie]) {
    container.viewContext.performAndWait {
      saveDataToCoreData(movies: movies)
      UserDefaults.standard.set(Date(), forKey:  "LastRun")
    }
  }
  
  func saveDataOf(genres: [Genre]) {
    container.viewContext.performAndWait {
      deleteGenres()
      saveGenresToCoreData(genres: genres)
    }
  }
  
  private func deleteGenres() {
    container.viewContext.performAndWait {
      do {
        let objects = try container.viewContext.fetch(GenreEntity.fetchRequest())
        _ = objects.map { container.viewContext.delete($0) }
        try container.viewContext.save()
      } catch {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func deleteMovies() {
    container.viewContext.performAndWait {
      do {
        let objects = try container.viewContext.fetch(MovieEntity.fetchRequest())
        _ = objects.map { container.viewContext.delete($0) }
        try container.viewContext.save()
      } catch {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  private func saveDataToCoreData(movies: [Movie]) {
    container.viewContext.performAndWait {
      for movie in movies {
        let movieEntity: MovieEntity = MovieEntity(context: container.viewContext)
        movieEntity.id =  movie.id
        movieEntity.title = movie.title
        movieEntity.voteAverage = movie.voteAverage ?? 0
        movieEntity.posterPath = movie.posterPath
        movieEntity.backdropPath = movie.backdropPath
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
  
  func updateDataToCoreData(movie: Movie) -> MovieEntity {
    let fetch = MovieEntity.movieFetchRequest
    fetch.predicate = NSPredicate(format: "id == %d", movie.id)
    let moviee = moviesEntity.first { $0.id == movie.id }
    moviee?.objectWillChange.send()
    
    container.viewContext.performAndWait {
      moviee?.homepage = movie.homepage
      moviee?.runtime = movie.runtime ?? 0
      moviee?.overview = movie.overview
      do {
        try container.viewContext.save()
      } catch {
        fatalError("Failure to update context: \(error)")
      }
    }
    guard let moviea = moviee else { return MovieEntity(context: container.viewContext) }
    return moviea
  }
  
  private func saveGenresToCoreData(genres: [Genre]) {
    container.viewContext.perform {
      for genre in genres {
        let genreEntity = GenreEntity(context: self.container.viewContext)
        genreEntity.id = genre.id
        genreEntity.name = genre.name
      }
      do {
        try self.container.viewContext.save()
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
}

extension PersistenceManager: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let movies = controller.fetchedObjects as? [MovieEntity] else { return }
    moviesEntity = movies
  }
}

extension MovieEntity {
  static var movieFetchRequest: NSFetchRequest<MovieEntity> {
    let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "voteAverage", ascending: false)]
    
    return request
  }
}
