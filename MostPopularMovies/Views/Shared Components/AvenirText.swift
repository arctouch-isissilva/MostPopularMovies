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
  let fontType: Font?
  
  var body: some View {
    Text(text)
      .font(.custom("Avenir Heavy", size: textSize))
      .font(fontType)
      .foregroundColor(.white)
      .lineLimit(2)
  }
}
