//
//  NavigationRoute.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

enum NavigationRoute: Identifiable, Hashable {
    
    case testPush
    
    var id: String {
        String(describing: self)
    }
    
    
    @ViewBuilder
    var view: some View {
        Text("Push")
    }
}
