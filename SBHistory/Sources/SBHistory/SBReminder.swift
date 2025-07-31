//
//  Reminder.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

import Foundation
import SwiftData

public typealias SBReminder = ShiftBeeSchemaV2.Reminder


public extension ShiftBeeSchemaV2 {
    @Model
    public final class Reminder {
        @Attribute(.unique)
        public var id: UUID
        public var title: String
        public var dueDate: Date
        public var isCompleted: Bool
        
        public init(title: String, dueDate: Date, isCompleted: Bool = false) {
            self.id = UUID()
            self.title = title
            self.dueDate = dueDate
            self.isCompleted = isCompleted
        }
        
    }

}

