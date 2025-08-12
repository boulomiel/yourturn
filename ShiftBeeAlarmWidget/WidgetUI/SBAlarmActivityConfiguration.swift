//
//  SBAlarmActivityConfiguration.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import SwiftUI
import WidgetKit

struct SBAlarmActivityConfiguration: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SBAlarmActivity.self) { context in
            // LockScreen UI - the rounded rectangle - rendered for each update
            Text("")
              //  .activityBackgroundTint(<#T##color: Color?##Color?#>)
              //  .activitySystemActionForegroundColor(<#T##color: Color?##Color?#>)
        } dynamicIsland: { context in // static, dynamic attributes, id
            /// UI Dynamic island
            /// compactLeading and compactTrailing - informative UI
            /// minimalView should only contain most critical information
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Expanded - Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Expanded - trailing")

                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Expanded - center")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Expanded - bottom")
                }
            } compactLeading: {
                Text("compactLeading")
            } compactTrailing: {
                Text("compactTrailing")
            } minimal: {
                Text("minimal")
            }

        }

    }
}




//
//#Preview {
//    SBAlarmActivityConfiguration()
//}
