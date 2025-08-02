//
//  YourTurnApp.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SBHistory
import OSLog
import SwiftUI
import SwiftData

@main
struct ShiftBeeApp: App {
    
    var sharedModelContainer: ModelContainer = {
        do {
            return try setupModelContainer()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var history: SBHistoryManager {
        return .init(modelContainer: sharedModelContainer)
    }

    var body: some Scene {
        WindowGroup {
//            SBCalendarPicker(selectionObs: .init(history: history))
//                .preferredColorScheme(.dark)
            ActivityView()
        }
        .modelContainer(sharedModelContainer)
        .environment(history)
        .environment(ShiftBeeLocationManager())
    }
}

struct Preview {
    
    let modelContainer: ModelContainer
    let history: SBHistoryManager
    
    init() {
        let schema = Schema(ShiftBeeSchemaV2.models)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.history = .init(modelContainer: modelContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}


extension ShiftBeeApp {
    
    static var previewContainer: ModelContainer {
        let schema = Schema(ShiftBeeSchemaV2.models)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    static let logger = Logger(subsystem: "com.shiftbee.SwiftData", category: "App")

    static func setupModelContainer(for versionedSchema: VersionedSchema.Type = ShiftBeeSchemaV2.self, rollback: Bool = false) throws -> ModelContainer {
        do {
            logger.info("setup - versionedSchema: \(String(describing: versionedSchema))")
            
            // schema
            let schema = Schema(versionedSchema: versionedSchema)
            logger.info("setup - schema: \(String(describing: schema))")
            
            // config
            var config: ModelConfiguration
            
            config = ModelConfiguration(schema: schema)

            logger.info("setup - config: \(String(describing: config))")
            
            print("SETUP","Creating Container")
            // container
            let container = try ModelContainer(
                for: schema,
                migrationPlan: rollback ? RollbackV2toV1.self : MigrationPlan.self,
                configurations: config
            )

            logger.info("setup -> \(String(describing: container))")
            
            return container
        } catch {
            logger.error("setup - \(error)")
            throw ModelError.setup(error: error)
        }
    }

    enum ModelError: LocalizedError {
        case setup(error: Error)
    }
}
