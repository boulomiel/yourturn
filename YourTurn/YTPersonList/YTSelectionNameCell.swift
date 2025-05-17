//
//  SelectionNameCell.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import NaturalLanguage
import SwiftUI
import Combine

struct YTSelectionNameCell: View {
    
    @State var obs: Obs
    
    var body: some View {
        Group {
            if obs.isLast {
                FocusAppearField(name: "", getNameEvent: obs.getNameEvent)
            } else {
                HStack {
                    TextField(obs.name, text: .constant(obs.name))
                        .disabled(true)
                        .foregroundStyle(.gray)
                        .onAppear {
                            obs.detectLanguageDirection()
                        }
                    
                    if let time = obs.time {
                        TextField(time.hoursAndMinutesPeriod, text: .constant(time.hoursAndMinutesPeriod))
                            .disabled(true)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
    
    @Observable
    class Obs: Identifiable, Equatable {
        
        static func ==(lhs: Obs, rhs: Obs) -> Bool {
            lhs.id == rhs.id
        }
        
        let id: UUID = .init()
        var name: String
        let time: Date?
        var isLast: Bool
        let getNameEvent: PassthroughSubject<FocusAppearField.FAFEvent, Never>
        let languageRecognizer: NLLanguageRecognizer
        var isRightToLeft: Bool
        
        private var cancellable: AnyCancellable?
        
        init(name: String, time: Date?, isLast: Bool, getNameEvent: PassthroughSubject<FocusAppearField.FAFEvent, Never>, languageRecognizer: NLLanguageRecognizer = .init()) {
            self.name = name
            self.time = time
            self.isLast = isLast
            self.languageRecognizer = languageRecognizer
            self.getNameEvent = getNameEvent
            self.isRightToLeft = false
            observeInput()
        }
        
        func detectLanguageDirection() {
            detectLanguageDirection(text: name)
        }
        
        func detectLanguageDirection(text: String) {
            languageRecognizer.processString(text)
            if let language = languageRecognizer.dominantLanguage {
                self.isRightToLeft = language.isRightToLeft
            }
        }
        
        private func observeInput() {
            cancellable = getNameEvent
                .compactMap {
                    if case .onChange(name: let name) = $0 {
                        return name
                    } else {
                        return nil
                    }
                }
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: {[weak self] name in
                    self?.detectLanguageDirection(text: name)
                })
        }
    }
}
