//
//  YTHourShiftError.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//


enum YTHourShiftError: YTErrorPopupProtocol, Error {

    case error
    case nameErrors(YTNameError)

    
    var localizedDescription: String {
        switch self {
        case .error:
            ""
        case .nameErrors(let error):
            error.localizedDescription
        }
    }
}
