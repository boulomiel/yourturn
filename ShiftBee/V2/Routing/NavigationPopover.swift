//
//  NavigationPopover.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

enum NavigationPopover: Identifiable {
    
    case testPopover
    
    var id: String {
        String(describing: self)
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .testPopover:
            Text("TestPopover")
        }
    }

}
