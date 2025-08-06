//
//  SBAlarmManager.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import AlarmKit

nonisolated
class SBAlarmManager {
    
    enum SBAlarmPermissionState {
        case notGrantedYet
        case granted
        case denied
        case error(Error)
    }
    
    let manager: AlarmManager = .shared
    let (stream, continuation) =  AsyncStream.makeStream(of: SBAlarmPermissionState.self)
    
    func checkAuthorization() async {
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
    
    func requestAuthorization() async  {
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
            ShiftBeeApp.logger.error("\(#function) - \(error)")
        }
    }
}
