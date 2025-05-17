//
//  Station.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 13/05/2025.
//

import Foundation
import SwiftData

@Model
final class Station {
    
    @Attribute(.unique)
    var date: Date
    
    private var _names: Data
    
    var names: [String] {
        YTStorage.loadStringArray(data: _names)
    }
    
    init(stations: [String]) {
        self.date = Date()
        self._names = YTStorage.archiveStringArray(object: stations)
    }
}
