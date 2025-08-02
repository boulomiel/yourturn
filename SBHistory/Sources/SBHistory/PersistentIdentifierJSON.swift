//
//  PersistentIdentifierJSON.swift
//  SBHistory
//
//  Created by Ruben Mimoun on 01/08/2025.
//

import Foundation
import SwiftData

public struct PersistentIdentifierJSON: Codable {
    public struct Implementation: Codable {
        var primaryKey: String
        var uriRepresentation: URL
        var isTemporary: Bool
        var storeIdentifier: String
        var entityName: String
    }
    
    var implementation: Implementation
}

public extension PersistentIdentifier {
    public static func customIdentifier(for storeIdentifier: String =  UUID().uuidString, entityName: String, primaryKey: String = String(describing: Date.now.timeIntervalSince1970)) throws
    -> PersistentIdentifier
    {
        let uriRepresentation = URL(string: "x-coredata://\(storeIdentifier)/\(entityName)/\(primaryKey)")!
        let json = PersistentIdentifierJSON(
            implementation: .init(
                primaryKey: primaryKey,
                uriRepresentation: uriRepresentation,
                isTemporary: false,
                storeIdentifier: storeIdentifier,
                entityName: entityName)
        )
        let encoder = JSONEncoder()
        let data = try encoder.encode(json)
        let decoder = JSONDecoder()
        return try decoder.decode(PersistentIdentifier.self, from: data)
    }
}

// let id = try! PersistentIdentifier.customIdentifier(for: "A07B3AB6-F28D-4F15-9B5D-9B12EB052BC6", entityName: "Item", primaryKey: "p1")
 // print(id)

// PersistentIdentifier(id: SwiftData.PersistentIdentifier.ID(url: x-coredata://A07B3AB6-F28D-4F15-9B5D-9B12EB052BC6/Item/p1), implementation: SwiftData.PersistentIdentifierImplementation)
