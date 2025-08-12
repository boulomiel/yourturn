//
//  SBAlarmBuilder.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import OSLog
import SwiftUI
import AlarmKit
import ActivityKit

public class SBAlarmBuilder {
    
    nonisolated static let logger = Logger(subsystem: "com.shiftbee.SBAlarmBuilder", category: "App")
    
    typealias SBAlarmBuilderResult = Result<Alarm, SBAlarmBuilderError>
    
    @frozen
    public enum SBAlarmBuilderError: LocalizedError {
        case setup(error: any Error, item: AlarmItem)
        case moreThanOneConfig
    }
    
    @frozen
    public nonisolated struct AlarmItem: Identifiable, Sendable {
        
        public var id: UUID = .init()
        let title: LocalizedStringResource
        let schedule: Alarm.Schedule
        let countdown: Alarm.CountdownDuration?
        let stopButton: AlarmButton
        let secondaryButton: AlarmButton?
        let secondaryButtonBehavior: AlarmPresentation.Alert.SecondaryButtonBehavior?
        let sound: AlertConfiguration.AlertSound?
        
        fileprivate init(
            id: UUID,
            title: LocalizedStringResource,
            schedule: Alarm.Schedule,
            countdown: Alarm.CountdownDuration?,
            stopButton: AlarmButton,
            secondaryButton: AlarmButton?,
            secondaryButtonBehavior: AlarmPresentation.Alert.SecondaryButtonBehavior?,
            sound: AlertConfiguration.AlertSound?
        ) {
            self.id = id
            self.title = title
            self.schedule = schedule
            self.countdown = countdown
            self.stopButton = stopButton
            self.secondaryButton = secondaryButton
            self.secondaryButtonBehavior = secondaryButtonBehavior
            self.sound = sound
        }
        
        init(id: UUID = .init(),
             title: LocalizedStringResource,
             schedule: Alarm.Schedule,
             stopButton: AlarmButton
        ) {
            self.id = id
            self.title = title
            self.stopButton = stopButton
            self.schedule = schedule
            self.countdown = nil
            self.secondaryButton = nil
            self.secondaryButtonBehavior = nil
            self.sound = nil
        }
        
        public func addCountDown(_ countdown: Alarm.CountdownDuration) -> Self {
            return .init(id: id,
                         title: title,
                         schedule: schedule,
                         countdown: countdown,
                         stopButton: stopButton,
                         secondaryButton: secondaryButton,
                         secondaryButtonBehavior: secondaryButtonBehavior,
                         sound: sound)
        }
        
        public func addSecondaryButton(_ secondaryButton: AlarmButton) -> Self {
            return .init(id: id,
                         title: title,
                         schedule: schedule,
                         countdown: countdown,
                         stopButton: stopButton,
                         secondaryButton: secondaryButton,
                         secondaryButtonBehavior: secondaryButtonBehavior,
                         sound: sound)
        }
        
        public func addSecondaryButtonBehavior(_ secondaryButtonBehavior: AlarmPresentation.Alert.SecondaryButtonBehavior) -> Self {
            return .init(id: id,
                         title: title,
                         schedule: schedule,
                         countdown: countdown,
                         stopButton: stopButton,
                         secondaryButton: secondaryButton,
                         secondaryButtonBehavior: secondaryButtonBehavior,
                         sound: sound)
        }
        
        private var alerPresentation: AlarmPresentation.Alert {
            .init(title: title,
                  stopButton: stopButton,
                  secondaryButton: secondaryButton,
                  secondaryButtonBehavior: secondaryButtonBehavior)
        }
        
        private var alarmAttributes: AlarmAttributes<SBAlarmMetadata> {
            .init(presentation: .init(alert: alerPresentation), tintColor: .green)
        }
        
        var alarmConfiguration: AlarmManager.AlarmConfiguration<SBAlarmMetadata> {
            .init(countdownDuration: countdown,
                  schedule: schedule,
                  attributes: alarmAttributes,
                  sound: sound == nil ? .default : sound!
            )
        }
    }
    
    
    private let manager: SBAlarmManager
    
    private var alarms: [AlarmItem] = []
    
    public init(manager: SBAlarmManager) {
        self.manager = manager
    }
    
    public func addAlarm(alarmItem: AlarmItem) -> Self {
        self.alarms.append(alarmItem)
        return self
    }
    
    public func getUniqueConfig() -> AlarmManager.AlarmConfiguration<SBAlarmMetadata> {
        guard alarms.count == 1 else {
            fatalError("\(#function) - \(SBAlarmBuilderError.moreThanOneConfig)")
        }
        return alarms[0].alarmConfiguration
    }
    
    public func getUniqueAlarm() -> AlarmItem {
        guard alarms.count == 1 else {
            fatalError("\(#function) - \(SBAlarmBuilderError.moreThanOneConfig)")
        }
        return alarms[0]
    }
    
    public func scheduleAlarms() async -> [Alarm] {
        let items = alarms
        let manager = self.manager
        return await withTaskGroup(of: Result<Alarm, SBAlarmBuilderError>.self) { group in
            for item in items {
                group.addTask {
                    do {
                        let alarm = try await manager.setAlarm(id: item.id, to: item.alarmConfiguration)
                        return .success(alarm)
                    } catch {
                        return .failure(.setup(error: error, item: item))
                    }
                }
            }
            var results: [Alarm] = []
            for await result in group {
                switch result {
                case .success(let alarm):
                    results.append(alarm)
                case .failure(let error):
                    Self.logger.error("\(#function)\n\(error)")
                }
            }
            return results
        }
    }
}
