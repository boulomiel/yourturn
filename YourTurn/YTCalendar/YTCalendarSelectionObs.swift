//
//  YTCalendarSelectionObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftUI
import SwiftData
import Foundation

extension Array: @unchecked Sendable { }


@Observable
@MainActor
class YTCalendarSelectionObs {
    
    let history: BackgroundSerialPersistenceActor
    var count: Int = 0
    
    init(history: BackgroundSerialPersistenceActor) {
        self.history = history
    }
    
    enum YTSelectionError: YTErrorPopupProtocol {
        case secondTimeMustBeBigger
        
        var localizedDescription: String {
            switch self {
            case .secondTimeMustBeBigger:
                "The end date can’t be earlier than the start date. Please choose a valid range."
            }
        }
    }
    
    enum YTSelectionInfo: YTInfoPopupProtocol {
        case info

        var localizedDescription: String {
            ""
        }
    }
    
    struct SelectedDate: Hashable {
        let index: Int
        let date: Date
    }
    
    var calendarPopup: YTPopupState<YTSelectionInfo, YTSelectionError> = .idle
    var canShowErrorText: Bool = false
    var firstDate: SelectedDate?
    var secondDate: SelectedDate?
    
    var range: ClosedRange<Date>? {
        if let firstDate, let secondDate {
            firstDate.date...secondDate.date
        } else {
            nil
        }
    }
    
    func handleSelectedDate(at index: Int, with date: Date) {
        firstDate = .init(index: index, date: date)
    }
    
    func handleMultipleSelectedDate(at index: Int, with date: Date) {
        if firstDate == nil {
            firstDate = .init(index: index, date: date)
            return
        }
        if secondDate == nil {
            if let firstDate = firstDate?.date, firstDate < date  {
                secondDate = .init(index: index, date: date)
            } else {
                showSelectionError(.secondTimeMustBeBigger)
                firstDate = nil
                secondDate = nil
            }
            return
        }
        firstDate = nil
        secondDate = nil
    }
    
    func showSelectionError(_ error: YTSelectionError) {
        withAnimation {
            calendarPopup = .error(error: error)
        }
        withAnimation(.linear.delay(2.0)) {
            canShowErrorText = true
        }
        withAnimation(.linear.delay(5.0)) {
            calendarPopup = .idle
        }
        withAnimation(.linear.delay(4.0)) {
            canShowErrorText = false
        }
    }
    
    func fetchCount() async {
        do {
            self.count = try await history.fetchCount(Shift.self)
        } catch {
            print(error)
        }
    }
    
}

