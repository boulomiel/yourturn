//
//  SBHourShiftObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SBHistory
import SwiftUI
import SwiftData
import Combine

@Observable
@MainActor
class SBHourShiftObs {
        
    // - States
    var shiftCase: SBShiftCase
    var startHour: Date
    var endHour: Date
    var popupState: SBPopupState<SBHourShiftInfo, SBHourShiftError>
    var shareLink: URL?
    var shiftIdentifier: PersistentIdentifier?
   // var persons: [SBPerson]
    
    // -  Store
    var shiftStore: SBHourShiftStore
    var persons: [SBPerson] {
        get {
            shiftStore.persons
        }
        set {
            shiftStore.setPersons(newValue)
        }
    }
    let converter: SBCSVConverter
    let getNameEvent: PassthroughSubject<FocusAppearField.FAFEvent, Never> = .init()

    // Constructor
    let modelContainer: ModelContainer
    let date: Date
    
    init(modelContainer: ModelContainer, date: Date) {
        self.date = date
        self.shiftCase = .time
        self.shiftStore = .init(persons: [.init(name: "", time: nil)], stations: [])
        self.startHour = date
        self.endHour = date.advanced(by: 60 * 60 / 2)
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
            saveCSV()
            saveCurrentList()
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
        var copy = shiftStore.persons
        for i in 0..<copy.count {
            let date = startHour.advanced(by: Double(i) * timePerPerson)
            copy[i].time = date
        }
        self.shiftStore.setPersons(copy)
    }
    
    private func saveCSV() {
        shareLink = shiftStore.persons.generatePDF()
    }
    
    private func getTimePerPerson() -> TimeInterval? {
        let count = shiftStore.persons.count
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
//        let moc = modelContainer.mainContext
//        let shiftDate = date
//        do {
//            let predicate = #Predicate<SBShift>{ shift in
//                shift.date == shiftDate
//            }
//            var descriptor = FetchDescriptor<SBShift>(predicate: predicate)
//            descriptor.fetchLimit = 1
//            
//            let result = try moc.fetch(descriptor)
//            if let dateFound = result.first {
//                self.shiftStore.setPersons( dateFound.persons.map { SBPerson(name: $0.name) })
//                self.startHour = dateFound.startDate
//                self.endHour = dateFound.endDate
//                self.shiftIdentifier = dateFound.id
//            }
//        } catch {
//            print(error)
//        }
    }
    
    func removeCurrentShift() {
//        let moc = modelContainer.mainContext
//        guard let idenfitier = shiftIdentifier else { return }
//        do {
//            try moc.delete(model: SBShift.self, where: #Predicate { $0.id  == idenfitier })
//            try moc.save()
//        } catch {
//            print(error)
//        }
    }
    
    func saveCurrentList() {
        let usernames = shiftStore.persons.map(\.name).filter { !$0.isEmpty }
        let moc = modelContainer.mainContext
        let shift = SBShift(domainId: .init(), timestamp: Date.now.timeIntervalSince1970, date: date, startDate: startHour, endDate: endHour, persons: usernames.map { .init(domainId: .init(), timestamp: Date.now.timeIntervalSince1970, name: $0) })
        do {
            moc.insert(shift)
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func fetchTeamCount() -> Int {
        let moc = modelContainer.mainContext
        do {
            let fetchDescriptor = FetchDescriptor<SBTeam>()
            return try moc.fetchCount(fetchDescriptor)
        } catch {
            print(error)
            return 0
        }
    }
}

