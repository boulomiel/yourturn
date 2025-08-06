//
//  ActivitySheet.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import SwiftUI
import CoreLocation

enum ActivitySheet: @MainActor NavigationItem {
    case none
    case mapZoom(userLocation: CLLocation, transitionId: String, mapSpace: Namespace.ID)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .none:
            EmptyView()
        case .mapZoom(let userLocation, let transitionId, let mapSpace):
            ActivityMapZoomZelectionView(userLocation: userLocation)
                .navigationTransition(.zoom(sourceID: transitionId, in: mapSpace))
        }
    }
    
    var onDismiss: (() -> Void)? {
        nil
    }
}
