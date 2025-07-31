//
//  Team.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftData
import Foundation

public typealias SBTeam = ShiftBeeSchemaV2.Team

extension ShiftBeeSchemaV1 {
    @Model
    public final class Team {
        
        @Attribute(.unique)
        public var name: String
        public var teamData: Data
        
        public var team: [String] {
            SBStorage.loadStringArray(data: teamData)
        }
        
        public init(name: String, teamData: Data) {
            self.name = name
            self.teamData = teamData
        }
    }
}


extension ShiftBeeSchemaV2 {
    @Model
    public final class Team {
        
        @Attribute(.unique)
        public var name: String
        
        public var team: [Person]
        
        public init(name: String, team: [Person]) {
            self.name = name
            self.team = team
        }
    }
}
