//
//  YTPersonListView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftUI
import Combine
import NaturalLanguage

struct YTPersonListView: View {
    
    @Environment(YTHourShiftObs.self) var hourShiftObs
    @Environment(\.dismiss) var dimiss
    @AppStorage("lastList") var lastList: Data?
    
    let helper: YTPersonListHelper = .init()
    
    var body: some View {
        List {
            memberList
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
        }
        .onReceive(hourShiftObs.getNameEvent) { event  in
            handleGetName(event)
        }
    }
    
    @ViewBuilder
    private var memberList: some View {
        ForEach(hourShiftObs.persons, id: \.id) { cellOb in
            YTSelectionNameCell(obs: .init(name: cellOb.name,
                                           time: cellOb.time,
                                           isLast: cellOb.name == hourShiftObs.persons.last?.name,
                                           getNameEvent: hourShiftObs.getNameEvent))
                .deleteDisabled(hourShiftObs.persons.count < 2 || cellOb == hourShiftObs.persons.last)
        }
        .onMove { indexSet, index in
            hourShiftObs.shiftStore.movePersons(from: indexSet, to: index)
        }
        .onDelete { offset in
            hourShiftObs.shiftStore.removePersons(at: offset)
        }
    }
    
    private func handleGetName(_ event: FocusAppearField.FAFEvent) {
        if case let .get(name: name) = event {
            let result = helper.onAddingNameTapped(name: name, in: hourShiftObs.persons)
            switch result {
            case .success(let success):
                hourShiftObs.getNameEvent.send(.received)
                hourShiftObs.persons = success
                print(hourShiftObs.persons.isEmpty)
            case .failure(let failure):
                withAnimation(.bouncy.logicallyComplete(after: 3.0)) {
                    hourShiftObs.persons[hourShiftObs.persons.count-1] = .init(name: "")
                    hourShiftObs.popupState = .error(error: .nameErrors(failure))
                } completion: {
                    withAnimation(.spring) {
                        hourShiftObs.popupState = .idle
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var hourShiftObs: YTHourShiftObs = .init(modelContainer: YourTurnApp.previewContainer, date: .now)
    NavigationStack {
        YTPersonListView()
            .preferredColorScheme(.dark)
    }
    .environment(hourShiftObs)
}
