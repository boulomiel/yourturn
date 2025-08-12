//
//  SBAlarmActivity.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import Foundation
import ActivityKit
import AlarmKit

@frozen
public struct SBAlarmActivity: ActivityAttributes {
    
    let alarmData: SBAlarmMetadata
    
    @frozen
    public struct ContentState: Codable & Hashable {
        let name: String
        let timeleft: Double
        
        fileprivate static let startTime: Date = .now
        
        static var testAlarm: SBAlarmActivity.ContentState {
            SBAlarmActivity.ContentState(name: "Test Alarm", timeleft: startTime.timeIntervalSince1970)
         }
         
        static var testAlarm2: SBAlarmActivity.ContentState {
            SBAlarmActivity.ContentState(name: "Test Alarm2", timeleft: startTime.addingTimeInterval(-10).timeIntervalSince1970)
         }
    }
    
}
