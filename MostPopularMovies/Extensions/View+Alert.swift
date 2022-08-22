//
//  View+Alert.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 22/08/22.
//

import SwiftUI

extension View {
  func errorAlert(error: Binding<MovieError?>, buttonTitle: String = "OK") -> some View {
    return alert(Text(error.wrappedValue?.title ?? ""), isPresented: .constant(error.wrappedValue != nil)) {} message: {
      Text(error.wrappedValue?.description ?? "")
    }
  }
}
