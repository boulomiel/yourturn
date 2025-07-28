//
//  SheetDate.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//

import Foundation

struct SheetDate: Identifiable {
    
    var id: TimeInterval {
        date.timeIntervalSince1970
    }
    let date: Date
}


struct SheetTeam: Identifiable, Hashable {    
    let id: UUID = .init()
}
