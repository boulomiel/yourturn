//
//  SBAlarmActivityManager.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import Foundation
import ActivityKit

/// Manages the lifecycle and state updates of alarm-related Live Activities using ActivityKit.
/// Handles requesting, updating, ending, and observing activities, and exposes a stream of lifecycle state changes.
@MainActor
public class SBAlarmActivityManager {
    
    @frozen
    public enum SBAlarmActivityManagerError: LocalizedError {
        case noActivityRequested
    }
    
    @frozen
    public enum SBAlarmActivityUpdateState {
        case active
        case ended
        case dimissed
        case stale
        case pending
        case notInitialized
    }
    
    private let attributes: SBAlarmActivity
    private let state: SBAlarmActivity.ContentState
    private var activity: Activity<SBAlarmActivity>?
    
    /// An AsyncStream emitting state updates for the managed alarm Live Activity.
    /// Use this stream to observe the lifecycle changes (pending, active, ended, etc.)
    /// of the associated activity in real time.
    public let stream: AsyncStream<SBAlarmActivityUpdateState>
    private let continuation: AsyncStream<SBAlarmActivityUpdateState>.Continuation

    public init(attributes: SBAlarmActivity,
         state: SBAlarmActivity.ContentState,
         activity: Activity<SBAlarmActivity>? = nil) {
        self.attributes = attributes
        self.state = state
        self.activity = activity
        (stream, continuation) = AsyncStream.makeStream(of: SBAlarmActivityUpdateState.self)
    }
    
    /// Requests a new alarm Live Activity with the provided attributes and content state.
    /// - Parameters:
    ///   - attributes: The alarm activity attributes.
    ///   - state: The content state for the activity.
    /// - Throws: An error if the activity cannot be requested.
    public func requestActivity(
        for attributes: SBAlarmActivity,
        with state: SBAlarmActivity.ContentState
    ) throws  {
        self.activity = try Activity.request(attributes: attributes,
                             content: .init(state: state,
                                            staleDate: nil,
                                            relevanceScore: 0.0))
    }
    
    /// Updates the current alarm Live Activity with new content state and optional alert configuration.
    /// - Parameters:
    ///   - content: The new content state to apply.
    ///   - staleDate: The date when the content becomes outdated. Default is now.
    ///   - alertConfiguration: Optional alert configuration.
    /// - Throws: `SBAlarmActivityManagerError.noActivityRequested` if no activity has been started.
    public func update(
        _ content: ActivityContent<SBAlarmActivity.ContentState>,
        staleDate: Date = .now,
        alertConfiguration: AlertConfiguration? = nil
    ) async throws {
        guard let activity else {
            throw SBAlarmActivityManagerError.noActivityRequested
        }
        await activity.update(content, alertConfiguration: alertConfiguration, timestamp: staleDate)
    }
    
    /// Ends the current alarm Live Activity with specified content and dismissal policy.
    /// - Parameters:
    ///   - content: The final content state for the activity.
    ///   - dismissalPolicy: The dismissal policy for the UI. Default is .default.
    ///   - timestamp: The time at which the activity is ended. Default is now.
    public func end(
        _ content: ActivityContent<SBAlarmActivity.ContentState>,
        dismissalPolicy: ActivityUIDismissalPolicy = .default,
        timestamp: Date = .now
    ) async {
        await activity?.end(content, dismissalPolicy: dismissalPolicy, timestamp: timestamp)
    }
    
    /// Starts observing the managed alarm Live Activity for state changes and emits updates through the stream.
    /// If no activity exists, yields the .notInitialized state.
    public func observe() {
        guard let activity else {
            continuation.yield(.notInitialized)
            return
        }
        Task {
            for await state in activity.activityStateUpdates {
                switch state {
                case .pending:
                    continuation.yield(.pending)
                case .active:
                    continuation.yield(.active)
                case .ended:
                    continuation.yield(.ended)
                case .dismissed:
                    continuation.yield(.dimissed)
                case .stale:
                    continuation.yield(.stale)
                @unknown default:
                    fatalError("\(#function) -  unknown: \(state)")
                }
            }
        }
    }
    
}

/// - Parameters :
///     - staleDate:  When the content is out of date
///     - relevanceScore: When multiple activities are ran at the same time,
///      it defines the order of which live activity appears - default: 0.0
///
