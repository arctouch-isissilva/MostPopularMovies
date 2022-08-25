//
//  View+DeviceOrientation.swift
//  MostPopularMovies
//
//  Created by Isis Silva on 23/08/22.
//

import SwiftUI

private struct DeviceOrientationViewModifier: ViewModifier {
  let action: (UIDeviceOrientation) -> Void
  
  func body(content: Content) -> some View {
    content
      .onAppear()
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
        action(UIDevice.current.orientation)
      }
  }
}

extension View {
  func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
    self.modifier(DeviceOrientationViewModifier(action: action))
  }
  
  @ViewBuilder
  func phoneOnlyStackNavigationView() -> some View {
    if UIDevice.current.userInterfaceIdiom == .phone {
      self.navigationViewStyle(.stack)
    } else {
      self
    }
  }
}
