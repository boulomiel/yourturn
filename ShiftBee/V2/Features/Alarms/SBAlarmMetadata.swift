//
//  AlarmData.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import AlarmKit

@frozen
public struct SBAlarmMetadata: AlarmMetadata {
    let title: String
}


extension SBAlarmMetadata {
    fileprivate static let date: Date = .now
    fileprivate static let startDate10 = date.addingTimeInterval(10)
    fileprivate static let startDate5 = startDate10.addingTimeInterval(-5)

    static let startTimeleft10: SBAlarmMetadata = .init(title: "Cooking")
    static let startTimeleft5: SBAlarmMetadata = .init(title: "Cooking")
}
