//
//  RollbackMigrationPlan.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

@preconcurrency import SwiftData

public enum RollbackV2toV1: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [ShiftBeeSchemaV2.self, ShiftBeeSchemaV1.self]
    }
    
    public static var stages: [MigrationStage] {
        [migrateV2toV1]
    }
    
    // MARK: Migration Stages
    public static let migrateV2toV1 = MigrationStage.custom(
        fromVersion: ShiftBeeSchemaV2.self,
        toVersion: ShiftBeeSchemaV1.self,
        willMigrate: nil,
        didMigrate: nil
    )
}
