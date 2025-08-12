//
//  SBShiftCase.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//


enum SBShiftCase: @MainActor SBSegmentValueCase {
    
    case time
    case persons
    case stations
    
    var name: String {
        switch self {
        case .time:
            "Time"
        case .persons:
            "Persons"
        case .stations:
            "Stations"
        }
    }
}
