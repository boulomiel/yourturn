//
//  Shift.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation
import SwiftData

@Model
final class Shift {
    
    @Attribute(.unique)
    var date: Date
    
    var startDate: Date
    var endDate: Date
    
    var data: Data
    
    var persons: [String] {
        YTStorage.loadStringArray(data: data)
    }
    
    init(date: Date, startDate: Date, endDate: Date, data: Data) {
        self.date = date
        self.startDate = startDate
        self.endDate = endDate
        self.data = data
    }
}
