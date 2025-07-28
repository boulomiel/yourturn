//
//  SBSegmentValueCase.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

protocol SBSegmentValueCase: CaseIterable, Hashable {
    var name: String { get }
}

enum SBSelectionCase: SBSegmentValueCase {
    case byDay
    case byPeriod
    
    var name: String {
        switch self {
        case .byDay:
            "Day"
        case .byPeriod:
            "Period"
        }
    }
}
