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
    var shiftIdentifier: PersistentIdentifier?
    
    // Constructor
    let history: BackgroundSerialPersistenceActor
    let modelContainer: ModelContainer
    let date: Date
    
    init(modelContainer: ModelContainer, date: Date) {
        self.date = date
        self.shiftCase = .time
        self.history = .init(container: modelContainer)
//        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
//        var advanced: TimeInterval = 0
//        if let hour = components.hour {
//            advanced += 60 * 60 * TimeInterval(hour)
//        }
//        if let minutes = components.minute {
//            advanced += 60 * TimeInterval(minutes)
//        }
//        let start = date.advanced(by: advanced)
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
        guard count > 1 else {
            removeCurrentShift()
            return nil
        }
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
                self.shiftIdentifier = dateFound.id
            }
        } catch {
            print(error)
        }
    }
    
    func removeCurrentShift() {
        let moc = modelContainer.mainContext
        guard let idenfitier = shiftIdentifier else { return }
        do {
            try moc.delete(model: Shift.self, where: #Predicate { $0.id  == idenfitier })
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func saveCurrentList() {
        let usernames = persons.map(\.name)
        let moc = modelContainer.mainContext
        let shift = Shift(date: date, startDate: startHour, endDate: endHour, data: YTStorage.archiveStringArray(object: usernames))
        do {
            moc.insert(shift)
            try moc.save()
        } catch {
            print(error)
        }
//        Task {
//            do {
//                 await history.insert(data: shift)
//            } catch {
//                print(error)
//            }
//        }
    }
    
    func fetchTeamCount() -> Int {
//        do {
//            return try await history.fetchCount(Shift.self)
//        } catch {
//            print(error)
//            return 0
//        }
        let moc = modelContainer.mainContext
        do {
            let fetchDescriptor = FetchDescriptor<Team>()
            return try moc.fetchCount(fetchDescriptor)
        } catch {
            print(error)
            return 0
        }
    }
}
