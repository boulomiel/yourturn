//
//  File.swift
//  SBHistory
//
//  Created by Ruben Mimoun on 31/07/2025.
//

import Foundation
import SwiftData

public typealias SBActivity = ShiftBeeSchemaV2.Activity

extension ShiftBeeSchemaV2 {
    @Model
    public final class Activity {
        @Attribute(.unique)
        public var domainId: UUID
        public var timestamp: TimeInterval
        public var title: String
        public var taskDescription: String?
        public var startDate: Date
        public var endDate: Date

//        public init(title: String, taskDescription: String?, startDate: Date, endDate: Date) {
//            self.domainId = .init()
//            self.title = title
//            self.taskDescription = taskDescription
//            self.startDate = startDate
//            self.endDate = endDate
//        }
        
        nonisolated public init(domainId: UUID, timestamp: TimeInterval, title: String, taskDescription: String?, startDate: Date, endDate: Date) {
            self.domainId = domainId
            self.timestamp = timestamp
            self.title = title
            self.taskDescription = taskDescription
            self.startDate = startDate
            self.endDate = endDate
        }
    }
}

public extension PersistentModel where Self == SBActivity {
    
}
