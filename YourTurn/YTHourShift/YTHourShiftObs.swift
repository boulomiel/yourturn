//
//  YTHourShiftObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
class YTHourShiftObs {
    
    var shiftCase: YTShiftCase
    
    var startHour: Date
    var endHour: Date
    var persons: [YTPerson]
    var popupState: YTPopupState<YTHourShiftInfo, YTHourShiftError>
    let converter: YTCSVConverter
    var shareLink: URL?
    let locolStorage = YTLocalStorage()
    var task: Task<Void, Never>?    
    
    // Constructor
    let modelContainer: ModelContainer
    let date: Date
    
    init(modelContainer: ModelContainer, date: Date) {
        self.date = date
        self.shiftCase = .time
        self.startHour = date
        self.endHour = date.advanced(by: 60 * 60 / 2)
        self.persons = []
        self.popupState = .idle
        self.converter = .init()
        self.modelContainer = modelContainer
    }
    
    func updateTime() {
        if let time = makeTime() {
            withAnimation {
                self.popupState = .info(info: .currentTime(time: time))
            }
            withAnimation(.linear.delay(4.0)) {
                self.popupState = .idle
            }
        }
    }
    
    func timePerPerson() {
        if let time = divideTime() {
            withAnimation {
                self.popupState = .info(info: .timePerPerson(time: time))
            }
            attributeTime()
        }
    }
    
    private func makeTime() -> String? {
        let calendar = Calendar.current
        let diffs = calendar.dateComponents([.hour, .minute], from: startHour, to: endHour)
        if let hour = diffs.hour, let minutes = diffs.minute {
            return "\(hour):\(minutes)"
        }
        return nil
    }
    
    private func divideTime() -> String? {
        guard let timePerPerson = getTimePerPerson() else {
            return nil
        }
        return timePerPerson.hoursAndMinutesPeriod
    }
    
    private func attributeTime() {
        guard let timePerPerson = getTimePerPerson() else {
            return
        }
        var copy = persons
        for i in 0..<copy.count {
            let date = startHour.advanced(by: Double(i) * timePerPerson)
            copy[i].time = date
        }
        self.persons = copy
        saveCSV()
        saveCurrentList()
    }
    
    private func saveCSV() {
        shareLink = converter.generatePDF(from: persons)
    }
    
    private func getTimePerPerson() -> TimeInterval? {
        let count = persons.count
        guard count > 1 else { return nil }
        let calendar = Calendar.current
        let diffs = calendar.dateComponents([.hour, .minute], from: startHour, to: endHour)
        var result: Double = 0
        if let hours = diffs.hour {
            result += 60 * Double(hours)
        }
        if let minutes = diffs.minute {
            result += Double(minutes)
        }
        let totalMinutes: TimeInterval = result * 60
        let timePerPerson = totalMinutes / Double(count)
        return timePerPerson
    }
    
    func fetchDateList() {
        let moc = modelContainer.mainContext
        let shiftDate = date
        do {
            let predicate = #Predicate<Shift>{ shift in
                shift.date == shiftDate
            }
            var descriptor = FetchDescriptor<Shift>(predicate: predicate)
            descriptor.fetchLimit = 1
            
            let result = try moc.fetch(descriptor)
            if let dateFound = result.first {
                self.persons = dateFound.persons.map { YTPerson(name: $0) }
                self.startHour = dateFound.startDate
                self.endHour = dateFound.endDate
            }
        } catch {
            print(error)
        }
    }
    
    private func saveCurrentList() {
        let usernames = persons.map(\.name)
        let moc = modelContainer.mainContext
        do {
            let shift = Shift(date: date, startDate: startHour, endDate: endHour, data: YTStorage.archiveStringArray(object: usernames))
            moc.insert(shift)
            try moc.save()
        } catch {
            print(error)
        }
    }
}
