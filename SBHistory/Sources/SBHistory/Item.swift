//
//  Item.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import Foundation
import SwiftData

public typealias Item = ShiftBeeSchemaV2.Item

extension ShiftBeeSchemaV1 {
    @Model
    public final class Item {
        public var timestamp: Date
        
        public init(timestamp: Date) {
            self.timestamp = timestamp
        }
    }

}


extension ShiftBeeSchemaV2 {
    @Model
    public final class Item {
        public var timestamp: Date
        
        public init(timestamp: Date) {
            self.timestamp = timestamp
        }
    }
}
