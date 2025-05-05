//
//  YTHourShiftInfo.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//


enum YTHourShiftInfo: YTInfoPopupProtocol {

    case currentTime(time: String)
    case timePerPerson(time: String)
    
    var localizedDescription: String {
        switch self {
        case .currentTime(let time):
            return time
        case .timePerPerson(time: let time):
            return time
        }
    }
}
