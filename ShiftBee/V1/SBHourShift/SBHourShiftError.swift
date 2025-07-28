//
//  SBHourShiftError.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

enum SBHourShiftError: SBErrorPopupProtocol, Error {

    case error
    case nameErrors(SBNameError)

    
    var localizedDescription: String {
        switch self {
        case .error:
            ""
        case .nameErrors(let error):
            error.localizedDescription
        }
    }
}
