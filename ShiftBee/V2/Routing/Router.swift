//
//  for.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

protocol RoutingProtocol {
    associatedtype Route: NavigationItem
    associatedtype SheetData: NavigationItem
    associatedtype PopoverData: NavigationItem
    
    var path: NavigationPath { get set }
    
    var sheetItem: SheetData? { get set }
    var popoverItem: PopoverData? { get set }
    
    func push(_ value: Route)
    func pop()
    
    func presentSheet(_ content: SheetData)
    func dismissSheet()
    
    func presentPopover(_ content: PopoverData)
    func dismissPopover()
}

/// A generic router class for SwiftUI NavigationStack, sheet, and popover presentation.
@Observable
final class Router<Route: NavigationItem, SheetData: NavigationItem, PopoverData: NavigationItem>: RoutingProtocol {
    // Core NavigationPath
    var path = NavigationPath()
    
    // For sheet and popover presentation
    var sheetItem: SheetData? = nil
    var popoverItem: PopoverData? = nil

    // MARK: - NavigationStack functions
    func push(_ value: Route) {
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

