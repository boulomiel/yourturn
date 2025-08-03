//
//  ActivitySheet.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//


enum ActivitySheet: @MainActor NavigationItem {
    case none
    
    @ViewBuilder
    var view: some View {
        
    }
    
    var onDismiss: (() -> Void)? {
        nil
    }
}
