//
//  SBPeronListObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import NaturalLanguage
import Combine
import SwiftUI

class SBPersonListHelper {
    
    func onAddingNameTapped(name: String, in persons: [SBPerson]) -> Result<[SBPerson], SBNameError> {
        var copy = persons
        let offset = persons.count-1
        
        guard !name.isEmpty, name.count >= 2 else {
            return .failure(.tooShort)
        }
        var set = Set(persons.map(\.name).dropLast())
        let (inserted, member) = set.insert(name)
        
        guard inserted else {
            return .failure(.nameAlreadyExists)
        }
        copy[offset] = .init(name: member)
        copy.append(.init(name: ""))
        return .success(copy)
    }
}
