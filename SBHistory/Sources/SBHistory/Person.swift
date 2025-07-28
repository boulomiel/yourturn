//
//  Person.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import SwiftData

public typealias Person = ShiftBeeSchemaV2.Person

extension ShiftBeeSchemaV2 {
    @Model
    public final class Person {
        
        @Attribute(.unique)
        public var name: String
        public var email: String?
        
        public init(name: String, email: String? = nil) {
            self.name = name
            self.email = email
        }
        
    }

}
