//
//  ToolbarItemPlacement+Extension.swift
//  SBExtensions
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import SwiftUI

public extension ToolbarItemPlacement {
    
    static var bottomPlatform: Self {
        #if os(macOS)
        .automatic
        #elseif os(iOS)
        .bottomBar
        #endif
    }
    
    static var topBarTrailingPlatform: Self {
        #if os(macOS)
        .primaryAction
        #elseif os(iOS)
        .topBarTrailing
        #endif
    }
}
