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
    var timestamp: TimeInterval { get }
    associatedtype SBHistoryEntity: SBDomainAccessProtocol
    func toEntity() -> SBHistoryEntity
}


/// Protocol to add to an extension on an `SB Entity` in order to convert it to a domain sendable struct
nonisolated public protocol SBDomainAccessProtocol {
    associatedtype DomainData: SBDomainProtocol
    var domainId: UUID { get }
    var timestamp: TimeInterval { get }
    func toDomainData() -> DomainData
}

enum SBHistoryManagerError: LocalizedError {
    case insertError(Error)
    case removeError(Error)
    case fetchError(Error)
    case updateError(Error)
}

@ModelActor
public actor SBHistoryManager: Observable {
        
    /// Insert an entity into the modelContainer
    /// - Parameter model: Entity to be inserted conforming to PersistenModel and SBDomainAccessProtocol
    public func insert<Domain>(_ model: Domain) throws where Domain: SBDomainProtocol, Domain.SBHistoryEntity: PersistentModel, Domain.ID == UUID {
        modelContext.insert(model.toEntity())
        postLastInserted(model: model)
        try modelContext.save()
    }
    
    /// Remove an entity from the modelContainer
    /// - Parameter model: Entity to be inserted conforming to PersistenModel and SBDomainAccessProtocol
    public func remove<DomainData: SBDomainProtocol>(_ model: DomainData) throws where DomainData.ID == UUID, DomainData.SBHistoryEntity: PersistentModel {
        let domainId = model.id
        try modelContext.delete(model: DomainData.SBHistoryEntity.self, where: #Predicate { $0.domainId == domainId })
        try modelContext.save()
    }
    
    /// Remove an entity from the modelContainer by  id when the model is Identifiable and the desired id to
    /// remove matches the model id type.
    /// - Parameter model: Entity to be inserted conforming to PersistenModel and SBDomainAccessProtocol
    public func remove<Model>(by id: UUID, for type: Model.Type) throws where Model: PersistentModel, Model: Identifiable, Model: SBDomainAccessProtocol ,Model.ID == UUID {
        let predicate = #Predicate<Model> { model in
            model.id == id
        }
        try modelContext.delete(model: type, where: predicate)
        try modelContext.save()
    }
    
    /// Fetches all the models given the following parameters
    /// - Parameters:
    ///   - predicate: #Predicate -  in order to filter the models, does not filter if nil
    ///   - sortDescriptors: The structural order for the returned list, random access if nil
    ///   - fetchLimit: Number items to fetch, max number fetched if nil
    ///   - fetchOffset: Define the start point of a range of items to fetch, base offset is 0 if nil
    ///   - propertiesToFetch: What properties will be accessible, fetch the entity as a whole if nil
    /// - Returns: List of PersistentModels
    public func fetch<Model: PersistentModel & SBDomainAccessProtocol, Domain: SBDomainProtocol>(
        predicate: Predicate<Model>?,
        sortDescriptors: [SortDescriptor<Model>]?,
        fetchLimit: Int? = nil,
        fetchOffset: Int? = nil,
        propertiesToFetch: [PartialKeyPath<Model>] = []
    ) throws -> [Domain] where Model: PersistentModel, Model.DomainData == Domain {
        var fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sortDescriptors ?? [])
        fetchDescriptor.fetchLimit = fetchLimit
        fetchDescriptor.fetchOffset = fetchOffset
        fetchDescriptor.propertiesToFetch = propertiesToFetch
        return try modelContext.fetch(fetchDescriptor).map { $0.toDomainData() }
    }
    
    public func fetchCount<T: PersistentModel>(
        _ model: T.Type,
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) throws -> Int {
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        let count = try modelContext.fetchCount(fetchDescriptor)
        return count
    }
    
    public func save() throws {
        try modelContext.save()
    }
    
    public func update(update: @escaping () -> SBModel) throws {
        let model = update()
        try modelContext.save()
    }
    
    
    /// Broadcast the latest inserted element in order to update the UI directly if needed by listening to `NotificationCenter.messages(of: history, for: NotificationCenter.AsyncMessage.SomeAsyncMessage.self)`
    /// when listening to the event, it is important to chec
    /// - Parameter model: domain data to be sent
    private func postLastInserted<Domain: SBDomainProtocol>(model : Domain) where Domain.ID == UUID {
        let lastMessage = LastInsertedMessage(type: Domain.self, id: model.id, lastItemTimestamp: model.timestamp)
        if #available(iOS 26.0, *) {
            NotificationCenter.default.post(lastMessage, subject: self)
        }
    }
    
    public struct LastInsertedMessage<Domain>: NotificationCenter.AsyncMessage {
        public typealias Subject = SBHistoryManager
        
        public let type: Domain.Type
        public let id: UUID
        public let lastItemTimestamp: TimeInterval
        
        public static var name: Notification.Name {
            .init(rawValue: "SBHistory.LastInsertedMessage")
        }
        
        public static func makeNotification(_ message: SBHistoryManager.LastInsertedMessage<Domain>) -> Notification {
            .init(name: name, object: self, userInfo: ["id": message.id, "type": message.type, "lastItemTimestamp": message.lastItemTimestamp])
        }
        
        public static func makeMessage(_ notification: Notification) -> SBHistoryManager.LastInsertedMessage<Domain>? {
            guard let userInfo = notification.userInfo,
                  let id = userInfo["id"] as? UUID,
                  let type = userInfo["type"] as? Domain.Type,
                  let lastItemTimestamp = userInfo["lastItemTimestamp"] as? TimeInterval else {
                return nil
            }
            return .init(type: type, id: id, lastItemTimestamp: lastItemTimestamp)
        }
    }

}
