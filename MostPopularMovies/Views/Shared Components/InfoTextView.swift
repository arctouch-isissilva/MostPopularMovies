//
//  InfoTextView.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 19/08/22.
//

import SwiftUI

struct InfoTextView: View {

  let infoText: String
  let dataText: String
  
  var body: some View {
    HStack {
      AvenirText(text: infoText, textSize: 14)
        .padding(.horizontal, 8)
      AvenirText(text: dataText, textSize: 14)
        .padding(.trailing, 8)
      Spacer()
    }
  }
}
