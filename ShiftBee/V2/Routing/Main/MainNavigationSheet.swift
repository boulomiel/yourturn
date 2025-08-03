//
//  NavigationSheet.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

enum MainNavigationSheet: @MainActor NavigationItem {
    
    case testSheet
    case createNewTask
    
    var id: String {
        String(describing: self)
    }
    
    var presentationDetents: Set<PresentationDetent> {
        switch self {
        case .createNewTask:
            [.height(100), .medium]
        default:
            []
        }
    }
    
    var onDismiss: (() -> Void)? {
        switch self {
        default:
            nil
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .testSheet:
            Text("Test Sheet")
        case .createNewTask:
            Text("New Task")
        }
    }
}




