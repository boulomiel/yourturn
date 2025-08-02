//
//  Person.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import SwiftData
import Foundation

public typealias SBPerson = ShiftBeeSchemaV2.Person

extension ShiftBeeSchemaV2 {
    @Model
    public final class Person {
        
        @Attribute(.unique)
        public var domainId: UUID
        public var timestamp: TimeInterval
        @Attribute(.unique)
        public var name: String
        public var email: String?

        public init(domainId: UUID, timestamp: TimeInterval, name: String, email: String? = nil) {
            self.domainId = domainId
            self.timestamp = timestamp
            self.name = name
            self.email = email
        }
        
    }

}

public struct PersonDomain: @MainActor SBDomainProtocol {

    @MainActor
    public func toEntity() -> SBPerson {
        .init(domainId: id, timestamp: timestamp, name: name, email: email)
    }
    
    public var id: UUID
    public var name: String
    public var email: String?
    public var timestamp: TimeInterval
    
    public typealias SBHistoryEntity = SBPerson
    
}

extension SBPerson: @MainActor SBDomainAccessProtocol {
    
    public typealias DomainData = PersonDomain

    @MainActor
    public func toDomainData() -> PersonDomain {
        .init(id: domainId, name: name, email: email, timestamp: timestamp)
    }
}
