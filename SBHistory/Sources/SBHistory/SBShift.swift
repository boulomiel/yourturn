//
//  Shift.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation
import SwiftData

public typealias SBShift = ShiftBeeSchemaV2.Shift

public extension ShiftBeeSchemaV1 {
    @Model
    public final class Shift {
        
        @Attribute(.unique)
        public var date: Date
        
        public var startDate: Date
        public var endDate: Date
        
        public var data: Data
        
        public var persons: [String] {
            SBStorage.loadStringArray(data: data)
        }
        
        public init(date: Date, startDate: Date, endDate: Date, data: Data) {
            self.date = date
            self.startDate = startDate
            self.endDate = endDate
            self.data = data
        }
    }
}



extension ShiftBeeSchemaV2 {
    @Model
    public final class Shift {
        
        @Attribute(.unique)
        public var date: Date
        
        public var startDate: Date
        public var endDate: Date
                
        public var persons: [Person]
        
        public init(date: Date, startDate: Date, endDate: Date, persons: [Person]) {
            self.date = date
            self.startDate = startDate
            self.endDate = endDate
            self.persons = persons
        }
    }
}






