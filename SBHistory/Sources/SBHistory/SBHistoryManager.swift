//
//  SBHistoryManager.swift
//  SBHistory
//
//  Created by Ruben Mimoun on 01/08/2025.
//

import Foundation
import SwiftData

public typealias SBModel = (any PersistentModel & SBDomainAccessProtocol)

/// Protocol required to conformed to be an illigebile struct to be a domain
/// data from a `SBHistory entities`
public protocol SBDomainProtocol: Sendable, Identifiable {
    
}

/// Protocol to add to an extension on an `SB Entity` in order to convert it to a domain sendable struct
public protocol SBDomainAccessProtocol {
    
    func toDomainData<D: SBDomainProtocol>() -> D
}

enum SBHistoryManagerError: LocalizedError {
    case insertError(Error)
    case removeError(Error)
    case fetchError(Error)
    case updateError(Error)
}

@ModelActor
actor SBHistoryManager {
    
    func insert(_ model: SBModel) throws {
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func remove(_ model: SBModel) throws {
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func remove<Model>(by id: UUID, for type: Model.Type) throws where Model: PersistentModel, Model: Identifiable, Model.ID == UUID {
        let predicate = #Predicate<Model> { model in
            model.id == id
        }
        try modelContext.delete(model: type, where: predicate)
        try modelContext.save()
    }
    
    func fetchAll<Model: PersistentModel>() throws -> [Model]{
        try modelContext.fetch(FetchDescriptor<Model>())
    }
    
    func fetch<Model: PersistentModel>(
        predicate: Predicate<Model>?,
        sortDescriptors: [SortDescriptor<Model>]?,
        fetchLimit: Int? = nil,
        fetchOffset: Int? = nil,
        propertiesToFetch: [PartialKeyPath<Model>] = []
    ) throws -> [Model] {
        var fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sortDescriptors ?? [])
        fetchDescriptor.fetchLimit = fetchLimit
        fetchDescriptor.fetchOffset = fetchOffset
        fetchDescriptor.propertiesToFetch = propertiesToFetch
        return try modelContext.fetch(fetchDescriptor)
    }
    
    func update(update: @escaping () -> ((any SBDomainProtocol) -> SBModel)) throws {
        let model = update()
        try modelContext.save()
    }
}
