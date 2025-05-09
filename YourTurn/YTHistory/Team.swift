//
//  Team.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftData
import Foundation

@Model
final class Team {
    
    @Attribute(.unique)
    var name: String
    var teamData: Data
    
    var team: [String] {
        YTStorage.loadStringArray(data: teamData)
    }
    
    init(name: String, teamData: Data) {
        self.name = name
        self.teamData = teamData
    }
}
