//
//  Station.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 13/05/2025.
//

import Foundation
import SwiftData

public typealias Station = ShiftBeeSchemaV2.Station

extension ShiftBeeSchemaV1 {
    @Model
    public final class Station {
        
        @Attribute(.unique)
        public var date: Date
        
        private var _names: Data
        
        public var names: [String] {
            SBStorage.loadStringArray(data: _names)
        }
        
        public init(stations: [String]) {
            self.date = Date()
            self._names = SBStorage.archiveStringArray(object: stations)
        }
    }

}

extension ShiftBeeSchemaV2 {
    @Model
    public final class Station {
        
        @Attribute(.unique)
        public var date: Date
        
        private var _names: Data
        
        public var names: [String] {
            SBStorage.loadStringArray(data: _names)
        }
        
        public init(stations: [String]) {
            self.date = Date()
            self._names = SBStorage.archiveStringArray(object: stations)
        }
    }

}
