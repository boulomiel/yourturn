//
//  Date+Extension.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation

extension Date {
    
    var hoursAndMinutesPeriod: String {
        let formatter = DateComponentsFormatter()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: components) ?? hoursAndMinutesFormatted
    }
    
    var hoursAndMinutesFormatted: String {
        self.formatted(date: .omitted, time: .shortened)
    }
}
