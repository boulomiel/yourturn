//
//  ShiftBeeAlarmWidget.swift
//  ShiftBeeAlarmWidget
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct ShiftBeeAlarmWidgetEntryView : View {
    var entry: AppIntentProvider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct ShiftBeeAlarmWidget: Widget {
    let kind: String = "ShiftBeeAlarmWidget"

    var body: some WidgetConfiguration {
        staticConfiguration
    }
    
    var appIntentConfiguration: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: AppIntentProvider()) { entry in
            ShiftBeeAlarmWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
    
    var staticConfiguration: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AppTimelineProvider()) { entry in
            ShiftBeeAlarmWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("AlarmApp")
        .description("This is an example widget")
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    ShiftBeeAlarmWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
