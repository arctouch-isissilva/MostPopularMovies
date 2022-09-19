//
//  MostPopularMoviesApp.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 16/08/22.
//

import SwiftUI

@main
struct MostPopularMoviesApp: App {
  let persistence = PersistenceManager.shared

  var body: some Scene {
    WindowGroup {
      MovieListView()
        .environment(\.managedObjectContext, persistence.container.viewContext)
    }
  }
}
