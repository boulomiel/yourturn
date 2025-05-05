//
//  YTPeronListObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import NaturalLanguage
import Combine
import SwiftUI

@Observable
class YTPeronListObs {
    var cellObs: [YTSelectionNameCell.Obs]
    var nameError: NameErrors = .idle
    var showTextError: Bool = false
    let languageRecognizer: NLLanguageRecognizer = .init()
    let getNameEvent: PassthroughSubject<FocusAppearField.FAFEvent, Never> = .init()
    
    init(person: [YTPerson]) {
        cellObs = []
        var obs :[YTSelectionNameCell.Obs] = []
        person.forEach { p in
            obs.append(.init(name: p.name, time: p.time, isLast: false, getNameEvent: getNameEvent))
        }
        cellObs = obs
        cellObs.append(.init(name: "", time: nil, isLast: true, getNameEvent: getNameEvent))
    }
    
    private var cancellable: AnyCancellable?
    
    
    func onAddingNameTapped() {
        guard !cellObs.isEmpty else { return }
        guard let (offset, cellOb) = Array(cellObs.enumerated()).last else { return }
        let name = cellOb.name
        guard !name.isEmpty, name.count >= 2 else {
            toggleError(error: .tooShort)
            return
        }
        var set = Set(cellObs.map(\.name).dropLast())
        let (inserted, _) = set.insert(name)
        guard inserted else {
            withAnimation {
                cellObs[offset].name = ""
            }
            toggleError(error: .nameAlreadyExists)
            return
        }
        cellObs[offset].isLast = false
        cellObs.append(.init(name: "", time: nil, isLast: true, getNameEvent: getNameEvent))
        getNameEvent.send(.received)
    }
    
    //        func resetObs(with list: [String]) {
    //            cellObs = list.map { name in
    //                YTSelectionNameCell.Obs(name: name, isLast: false, getNameEvent: getNameEvent)
    //            }
    //            cellObs.append(.init(name: "", isLast: true, getNameEvent: getNameEvent))
    //        }
    
    func toggleError(error: NameErrors) {
        withAnimation {
            self.nameError = error
        } completion: {
            withAnimation(.bouncy) {
                self.showTextError = true
            } completion: {
                withAnimation(.easeOut.delay(0.3)) {
                    self.showTextError = false
                } completion: {
                    withAnimation {
                        self.nameError = .idle
                    }
                }
            }
        }
    }
}
