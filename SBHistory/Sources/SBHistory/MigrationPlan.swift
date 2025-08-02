//
//  MigrationPlan.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import OSLog
import SwiftUI
import Foundation
import SwiftData

public enum MigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [ShiftBeeSchemaV1.self, ShiftBeeSchemaV2.self]
    }
    
    public static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    // MARK: Migration Stages
    
    public static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: ShiftBeeSchemaV1.self,
        toVersion: ShiftBeeSchemaV2.self,
        willMigrate: { context  in
            
            let items = try context.fetch(FetchDescriptor<ShiftBeeSchemaV1.Item>())
            var itemSave = Set<Date>()
            
            for item in items {
                if itemSave.contains(item.timestamp) {
                    context.delete(item)
                }
                itemSave.insert(item.timestamp)
            }
        },
        didMigrate: { context in
            
            let shifts = try context.fetch(FetchDescriptor<ShiftBeeSchemaV1.Shift>())
            for shift in shifts {
                let shiftV2 = ShiftBeeSchemaV2.Shift(domainId: .init(), timestamp: Date.now.timeIntervalSince1970, date: shift.date, startDate: shift.startDate, endDate: shift.endDate, persons: shift.persons.map { .init(domainId: .init(), timestamp: Date.now.timeIntervalSince1970, name: $0) })
                context.insert(shiftV2)
            }
            
            let stations = try context.fetch(FetchDescriptor<ShiftBeeSchemaV1.Station>())
            for station in stations {
                let stationV2 = ShiftBeeSchemaV2.Station(stations: station.names)
                context.insert(stationV2)
            }
            
            let teams = try context.fetch(FetchDescriptor<ShiftBeeSchemaV1.Team>())
            for team in teams {
                let teamV2 = ShiftBeeSchemaV2.Team(name: team.name, team: team.team.map { .init(domainId: .init(), timestamp: Date.now.timeIntervalSince1970, name: $0) })
                context.insert(teamV2)
            }
            
            try context.save()
        }
    )
}
