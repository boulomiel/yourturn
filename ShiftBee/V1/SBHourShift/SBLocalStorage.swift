//
//  LocalStorage.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SBHistory
import Foundation

actor SBLocalStorage {
    
    private let userDefaults = UserDefaults.standard
    
    func save(date: Date, list: [String]) {
        let list = SBStorage.archiveStringArray(object: list)
        userDefaults.set(list, forKey: date.formatted(date: .abbreviated, time: .omitted))
    }
    
    func get(date: Date, list: [String]) -> [String] {
        guard let data = userDefaults.data(forKey: date.formatted(date: .abbreviated, time: .omitted)) else {
            return []
        }
        return SBStorage.loadStringArray(data: data)
    }
}
