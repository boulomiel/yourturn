//
//  ShiftBeeAlarmWidgetBundle.swift
//  ShiftBeeAlarmWidget
//
//  Created by Ruben Mimoun on 06/08/2025.
//

import WidgetKit
import SwiftUI

@main
struct ShiftBeeAlarmWidgetBundle: WidgetBundle {
    var body: some Widget {
        ShiftBeeAlarmWidget()
        ShiftBeeAlarmWidgetControl()
        ShiftBeeAlarmWidgetLiveActivity()
    }
}
