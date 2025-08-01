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
nonisolated public protocol SBDomainProtocol: Identifiable {
    
}

/// Protocol to add to an extension on an `SB Entity` in order to convert it to a domain sendable struct
public protocol SBDomainAccessProtocol {
    associatedtype DomainData: SBDomainProtocol
    func toDomainData() -> DomainData
}

enum SBHistoryManagerError: LocalizedError {
    case insertError(Error)
    case removeError(Error)
    case fetchError(Error)
    case updateError(Error)
}

@ModelActor
actor SBHistoryManager {
    
    /// Insert an entity into the modelContainer
    /// - Parameter model: Entity to be inserted conforming to PersistenModel and SBDomainAccessProtocol
    func insert(_ model: SBModel) throws {
        modelContext.insert(model)
        try modelContext.save()
    }
    
    /// Remove an entity from the modelContainer
    /// - Parameter model: Entity to be inserted conforming to PersistenModel and SBDomainAccessProtocol
    func remove(_ model: SBModel) throws {
        modelContext.delete(model)
        try modelContext.save()
    }
    
    /// Remove an entity from the modelContainer by  id when the model is Identifiable and the desired id to
    /// remove matches the model id type.
    /// - Parameter model: Entity to be inserted conforming to PersistenModel and SBDomainAccessProtocol
    func remove<Model>(by id: UUID, for type: Model.Type) throws where Model: PersistentModel, Model: Identifiable, Model.ID == UUID {
        let predicate = #Predicate<Model> { model in
            model.id == id
        }
        try modelContext.delete(model: type, where: predicate)
        try modelContext.save()
    }
    
    /// Fetches all the models for a given type
    /// - Returns: A list of PersistenModel
    func fetchAll<Model: PersistentModel>() throws -> [Model] {
        try modelContext.fetch(FetchDescriptor<Model>())
    }
    
    /// Fetches all the models given the following parameters
    /// - Parameters:
    ///   - predicate: #Predicate -  in order to filter the models, does not filter if nil
    ///   - sortDescriptors: The structural order for the returned list, random access if nil
    ///   - fetchLimit: Number items to fetch, max number fetched if nil
    ///   - fetchOffset: Define the start point of a range of items to fetch, base offset is 0 if nil
    ///   - propertiesToFetch: What properties will be accessible, fetch the entity as a whole if nil
    /// - Returns: List of PersistentModels
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
    
    
    func update(update: @escaping () -> SBModel) throws {
        let model = update()
        try modelContext.save()
    }
}
