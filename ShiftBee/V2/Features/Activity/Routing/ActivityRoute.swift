//
//  ActivityRoute.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import SwiftUI

enum ActivityRoute: @MainActor NavigationItem {
    case none
    case mapView
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .mapView:
            ActivityMapView()
        default:
            EmptyView()
        }
    }
    
    var onDismiss: (() -> Void)? {
        nil
    }
}
