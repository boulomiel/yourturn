//
//  YTPerson.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//

import Foundation

struct YTPerson: Equatable, YTCSVConvertible, Identifiable {
    
    static var csvHeader: String {
        "Name,Time"
    }
    
    
    var csvRow: String {
        "\(name), \(period)"
    }
    
    let id: UUID = .init()
    var name: String
    var time: Date?
    
    var period: String {
        time?.hoursAndMinutesPeriod ?? ""
    }
    
}
