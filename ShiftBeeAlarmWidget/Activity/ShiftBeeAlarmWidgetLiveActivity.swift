//
//  ShiftBeeAlarmWidgetLiveActivity.swift
//  ShiftBeeAlarmWidget
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import AlarmKit
import ActivityKit
import WidgetKit
import SwiftUI

struct ShiftBeeAlarmWidgetLiveActivity: Widget {
    
    typealias Context = ActivityViewContext<AlarmAttributes<SBAlarmMetadata>>
    typealias CountDown = AlarmPresentationState.Mode.Countdown
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<SBAlarmMetadata>.self) { context in
            // Lock screen/banner UI goes here
            switch context.state.mode {
            case .countdown(let countdown):
                countDownView(context, countdown: countdown)
            default:
                Text("Blop")
            }

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("minimal")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    @ViewBuilder
    func countDownView(_ context: Context, countdown: CountDown) -> some View {
        let meta = context.attributes.metadata!
        let stopButton =                        context.attributes.presentation.alert.stopButton
        
        let pauseButton = context.attributes.presentation.alert.secondaryButton!

        HStack {
            VStack(alignment: .leading) {
                Text(meta.title)
                    .font(.system(size: 18).bold())
                Text("\(Double(countdown.totalCountdownDuration - countdown.previouslyElapsedDuration).alarmTimeFormat)")
                    .font(.system(size: 30).bold()).fontDesign(.rounded)
            }
            
            Spacer()
                                
            Button(pauseButton.text, systemImage: pauseButton.systemImageName) {
                
            }
            .tint(pauseButton.textColor)
            .background(Color.orange)
            .clipShape(Capsule())
            
            Button(stopButton.text, systemImage: stopButton.systemImageName) {
            }
            .tint(stopButton.textColor)
            .background(Color.red)
            .clipShape(Capsule())
        }
        .padding(.horizontal, 24)
    }
}

@MainActor let manager = SBAlarmManager()
@MainActor let builder = SBAlarmBuilder(manager: manager)

@MainActor var alarmItem:  SBAlarmBuilder.AlarmItem  =
    builder
        .addAlarm(alarmItem: .init(title: "Cooking",
                                   schedule: .fixed(.now.advanced(by: 60)),
                                   stopButton: .init(text: "Stop",
                                                     textColor: .white,
                                                     systemImageName: "stop.circle"))
            .addCountDown(.init(preAlert: 10, postAlert: 10))
            .addSecondaryButton(.init(text: "Pause", textColor: .white, systemImageName: "pause.circle"))
            .addSecondaryButtonBehavior(.custom)
        )
        .getUniqueAlarm()



#Preview(
    "SBAlarm",
    as: .content,
    using: AlarmAttributes<SBAlarmMetadata>(
        presentation: AlarmPresentation(
            alert: .init(
                title: alarmItem.title,
                stopButton: alarmItem.stopButton,
                secondaryButton: alarmItem.secondaryButton,
                secondaryButtonBehavior: alarmItem.secondaryButtonBehavior
            )
        ),
        metadata: .startTimeleft10,
        tintColor: .white
    )
) {
    ShiftBeeAlarmWidgetLiveActivity()
} contentStates: {
    AlarmPresentationState(alarmID: alarmItem.id,
                           mode: .countdown(.init(totalCountdownDuration: 60,
                                                  previouslyElapsedDuration: 24,
                                                  startDate: .now,
                                                  fireDate: .now.addingTimeInterval(36))))
    
    AlarmPresentationState(alarmID: alarmItem.id,
                           mode: .paused(.init(totalCountdownDuration: 60, previouslyElapsedDuration: 35)))
}

extension Double {
    
    var alarmTimeFormat: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
