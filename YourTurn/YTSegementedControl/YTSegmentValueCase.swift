//
//  YTSegmentValueCase.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//


protocol YTSegmentValueCase: CaseIterable, Hashable {
    var name: String { get }
}

enum YTSelectionCase: YTSegmentValueCase {
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