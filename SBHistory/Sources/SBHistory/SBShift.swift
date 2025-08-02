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
        public var timestamp: TimeInterval
        @Attribute(.unique)
        public var domainId: UUID
        public var startDate: Date
        public var endDate: Date
                
        public var persons: [Person]
        
        
        public init(domainId: UUID, timestamp: TimeInterval, date: Date, startDate: Date, endDate: Date, persons: [Person]) {
            self.domainId = domainId
            self.timestamp = timestamp
            self.date = date
            self.startDate = startDate
            self.endDate = endDate
            self.persons = persons
        }
    }
}

public struct ShiftDomain: @MainActor SBDomainProtocol {
    
    @MainActor
    public func toEntity() -> SBShift {
        .init(domainId: id, timestamp: timestamp, date: date, startDate: startDate, endDate: endDate, persons: persons)
    }
    
    public let id: UUID
    public var date: Date
    public var startDate: Date
    public var endDate: Date
    public var persons: [SBPerson]
    public var timestamp: TimeInterval
    
    public typealias SBHistoryEntity = SBShift
    
}

extension ShiftBeeSchemaV2.Shift: @MainActor SBDomainAccessProtocol {

    @MainActor
    public func toDomainData() -> ShiftDomain {
        .init(id: domainId, date: date, startDate: startDate, endDate: endDate, persons: persons, timestamp: timestamp)
    }
}






