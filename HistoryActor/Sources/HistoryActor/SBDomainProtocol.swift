//
//  SBDomainProtocol.swift
//  HistoryActor
//
//  Created by Ruben Mimoun on 12/08/2025.
//

import Foundation

public protocol SBDomainProtocol: Identifiable, Sendable {
    nonisolated var timestamp: TimeInterval { get }
    associatedtype SBHistoryEntity: SBDomainAccessProtocol
    nonisolated func toEntity() -> SBHistoryEntity
}

public protocol SBDomainAccessProtocol {
    associatedtype DomainData: SBDomainProtocol
    nonisolated var domainId: UUID { get }
    nonisolated var timestamp: TimeInterval { get }
    nonisolated func toDomainData() -> DomainData
}
