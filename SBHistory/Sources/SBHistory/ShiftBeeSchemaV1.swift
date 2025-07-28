//
//  ShiftBeeSchemaV1.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import SwiftData

public enum ShiftBeeSchemaV1: VersionedSchema {
    public static var models: [any PersistentModel.Type] {
        [
            Item.self, Shift.self, Team.self
        ]
        
    }
    
    public static let versionIdentifier: Schema.Version = .init(1, 0, 0)
}
