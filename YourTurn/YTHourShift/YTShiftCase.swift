//
//  YTShiftCase.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//


enum YTShiftCase: YTSegmentValueCase {
    
    case time
    case persons
    
    var name: String {
        switch self {
        case .time:
            "Time"
        case .persons:
            "Persons"
        }
    }
}