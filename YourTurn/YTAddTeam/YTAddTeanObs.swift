//
//  YTPeronListObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//


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
class YTAddTeanObs {
    
    var cellObs: [YTSelectionNameCell.Obs]
    var nameError: NameErrors = .idle
    var popupState: YTPopupState<YTHourShiftInfo, NameErrors>
    var showTextError: Bool = false
    let languageRecognizer: NLLanguageRecognizer = .init()
    let getNameEvent: PassthroughSubject<FocusAppearField.FAFEvent, Never> = .init()
    
    init() {
        cellObs = [.init(name: "", time: nil, isLast: true, getNameEvent: getNameEvent)]
        popupState = .idle
    }
    
    private var cancellable: AnyCancellable?
    
    
    func onAddingNameTapped() {
        guard !cellObs.isEmpty else { return }
        guard let last = cellObs.last else { return }
        let allNames = cellObs.dropLast().map { $0.name }
        guard !allNames.contains(last.name) else {
            toggleError(error: .nameAlreadyExists)
            return
        }
        guard last.name.count >= 2 else {
            toggleError(error: .tooShort)
            return
        }
        last.isLast = false
        cellObs.append(.init(name: "", time: nil, isLast: true, getNameEvent: getNameEvent))
        getNameEvent.send(.received)
    }
    
    func toggleError(error: NameErrors) {
        withAnimation {
            popupState = .error(error: error)
        } completion: {
            withAnimation(.bouncy) {
                self.showTextError = true
            }
        }
        withAnimation(.linear.delay(4.0)) {
            self.popupState = .idle
        }
    }
}
