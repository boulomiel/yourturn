//
//  YourTurnApp.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftUI
import SwiftData

@main
struct ShiftBeeApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Shift.self,
            Team.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var history: BackgroundSerialPersistenceActor {
        return BackgroundSerialPersistenceActor(container: sharedModelContainer)
    }

    var body: some Scene {
        WindowGroup {
            SBCalendarPicker(selectionObs: .init(history: history))
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(history)
    }
}

extension ShiftBeeApp {
    
    static var previewContainer: ModelContainer {
        let schema = Schema([
            Item.self,
            Shift.self,
            Team.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
