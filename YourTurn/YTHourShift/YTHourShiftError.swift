//
//  YTHourShiftError.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//


enum YTHourShiftError: YTErrorPopupProtocol {

    case error
    
    var localizedDescription: String {
        switch self {
        case .error:
            ""
        }
    }
}