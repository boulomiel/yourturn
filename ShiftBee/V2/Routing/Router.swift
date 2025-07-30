//
//  for.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

/// A generic router class for SwiftUI NavigationStack, sheet, and popover presentation.
@Observable
final class Router<SheetData: Identifiable, PopoverData: Identifiable> {
    // Core NavigationPath
    var path = NavigationPath()
    
    // For sheet and popover presentation
    var sheetItem: SheetData? = nil
    var popoverItem: PopoverData? = nil

    // MARK: - NavigationStack functions
    func push(_ value: any Hashable) {
        path.append(value)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    // MARK: - Sheet
    func presentSheet(_ content: SheetData) {
        sheetItem = content
    }
    func dismissSheet() {
        sheetItem = nil
    }
    
    // MARK: - Popover
    func presentPopover(_ content: PopoverData) {
        popoverItem = content
    }
    func dismissPopover() {
        popoverItem = nil
    }
}

