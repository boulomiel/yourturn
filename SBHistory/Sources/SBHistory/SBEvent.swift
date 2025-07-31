//
//  Event.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import Foundation
import SwiftData


public typealias SBEvent = ShiftBeeSchemaV2.Event

extension ShiftBeeSchemaV2 {
    @Model
    public final class Event {
        @Attribute(.unique)
        public var id: UUID
        public var title: String
        public var notes: String?
        public var date: Date
        public var startDate: Date
        public var endDate: Date
        public var associatedTeam: Team?
        public var participants: [String]
        
        public init(title: String, notes: String?, date: Date, startDate: Date, endDate: Date, team: Team?, participants: [String]) {
            self.id = UUID()
            self.title = title
            self.notes = notes
            self.date = date
            self.startDate = startDate
            self.endDate = endDate
            self.associatedTeam = team
            self.participants = participants
        }
    }
}
