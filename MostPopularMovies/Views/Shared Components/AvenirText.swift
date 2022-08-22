//
//  AvenirText.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 20/08/22.
//

import SwiftUI

struct AvenirText: View {
  let text: String
  let textSize: CGFloat

    var body: some View {
        Text(text)
        .font(.custom("Avenir Heavy", size: textSize))
        .foregroundColor(.white)
        .lineLimit(1)
    }
}
