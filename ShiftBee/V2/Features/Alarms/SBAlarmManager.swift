//
//  SBAlarmManager.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import OSLog
import AlarmKit
import ActivityKit

public struct SBAlarmManager: Sendable {
    
    @frozen
    public enum SBAlarmPermissionState {
        case notGrantedYet
        case granted
        case denied
        case error(any Error)
    }
    
    nonisolated(unsafe) private let manager: AlarmManager = .shared
    private let continuation: AsyncStream<SBAlarmPermissionState>.Continuation
    
    
    /// Listens to permission state of the alarm
    public let stream: AsyncStream<SBAlarmPermissionState>
    
    public init() {
        (stream, continuation) =  AsyncStream.makeStream(of: SBAlarmPermissionState.self)
    }
    
    // MARK: Permissions
    
    /// Checks the permission state to access to Alarm. If not given yet
    /// will request, otherwise will ping through 'AsyncStream<SBAlarmPermissionState>`
    /// in order to update UI or any event listener
    public func checkAuthorization() async {
        switch manager.authorizationState {
        case .notDetermined:
            await requestAuthorization()
        case .denied:
            continuation.yield(.denied)
        case .authorized:
            continuation.yield(.granted)
        @unknown default:
            fatalError(#function.appending("Unknown case - \(manager.authorizationState)"))
        }
    }
    
    private func requestAuthorization() async  {
        do {
            let status = try await manager.requestAuthorization()
            switch status {
            case .notDetermined:
                continuation.yield(.notGrantedYet)
            case .denied:
                continuation.yield(.denied)
            case .authorized:
                continuation.yield(.granted)
            @unknown default:
                fatalError(#function.appending("Unknown case - \(status)"))
            }
        } catch {
            continuation.yield(.error(error))
            SBAlarmBuilder.logger.error("\(#function) - \(error)")
        }
    }
    
    // MARK: Schedule
    
    /// Schedule  triggers and snooze loops for an alarm with a countdown duration
    /// - Parameters:
    ///   - preAlarm: Time in second, being the countdown before the alarm is triggered
    ///   - postAlarm: Time in second, once the alarm is snoozed it defines when the alarm will trigger again.
    /// - Returns: Alarm.CountdownDuration, the duration of the alarm to inject
    ///  in `AlarmManager.AlarmConfiguration`
    func scheduleCountDown(preAlarm: TimeInterval, postAlarm: TimeInterval) -> Alarm.CountdownDuration {
        Alarm.CountdownDuration.init(preAlert: preAlarm, postAlert: postAlarm)
    }
    
    
    /// Schedule alarm at a specific date only once
    /// - Parameter date: date and time for the alarm to trigger
    /// - Returns: Alarm.Schedule, the fixed date of the alarm to inject
    ///  in `AlarmManager.AlarmConfiguration`
    func scheduleFixedAlarm(to date: Date) -> Alarm.Schedule {
        Alarm.Schedule.fixed(date)
    }
    
    
    /// Schedules a relative alarm, recurses
    /// - Parameters:
    ///   - hours: Int, hour for the alarm to trigger
    ///   - minutes: Int, minutes for the alarm to trigger
    ///   - recurrences: Defines the recurrence days of the week of the alarm
    /// - Returns: Alarm.Schedule, the Relative date of the alarm to inject
    ///  in `AlarmManager.AlarmConfiguration`
    func scheduleRelativeAlarm(at hours: Int, and minutes: Int, recurrences: [Locale.Weekday]) -> Alarm.Schedule.Relative {
        let recurrences = Alarm.Schedule.Relative.Recurrence.weekly(recurrences)
        let time = Alarm.Schedule.Relative.Time(hour: hours, minute: minutes)
        
        return Alarm.Schedule.Relative(time: time, repeats: recurrences)
    }
    
    
    /// Setups an alarm in the app
    /// - Parameters:
    ///   - id: UUID, the alarm id in order to retrieve if needed (update, remove ...)
    ///   - config: AlarmManager.AlarmConfiguration instance
    /// - Returns: An object that describes an alarm that can alert once or on a repeating schedule.
    @discardableResult
    func setAlarm<MetaData>(id: UUID,
                            to config: sending AlarmManager.AlarmConfiguration<MetaData>) async throws -> Alarm where MetaData: AlarmMetadata {
        try await manager.schedule(id: id, configuration: config)
    }
}


