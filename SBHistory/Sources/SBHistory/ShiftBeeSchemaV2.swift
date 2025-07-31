//
//  ShiftBeeSchemaV2.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import SwiftData

public enum ShiftBeeSchemaV2: VersionedSchema {
    public static var models: [any PersistentModel.Type] {
        [
            // Previous Models
            ShiftBeeSchemaV1.Item.self,
            ShiftBeeSchemaV1.Shift.self,
            ShiftBeeSchemaV1.Team.self,
            // Updated Models
            Item.self,
            Shift.self,
            Team.self,
            Event.self,
            Reminder.self,
            Person.self,
            Activity.self
        ]
    }
    
    public static let versionIdentifier: Schema.Version = .init(2, 0, 0)
    
}
