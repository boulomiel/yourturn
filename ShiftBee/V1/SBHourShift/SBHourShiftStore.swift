//
//  SBHourShiftStore.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 13/05/2025.
//

import SwiftUI
import Foundation

struct SBHourShiftStore: Equatable {
    private(set) var persons: [SBPerson]
    private(set) var stations: [SBStation]
    
    init(persons: [SBPerson], stations: [SBStation]) {
        self.persons = persons
        self.stations = stations
    }
    
    mutating func setPersons(_ persons: [SBPerson]) {
        self.persons = persons
    }
    
    mutating func addPersons(_ persons: SBPerson...) {
        self.persons.append(contentsOf: persons)
    }
    
    mutating func movePersons(from indexSet: IndexSet, to destination: Int) {
        persons.move(fromOffsets: indexSet, toOffset: destination)
    }
    
    mutating func removePersons(at offsets: IndexSet...) {
        offsets.forEach { offset in
            persons.remove(atOffsets: offset)
        }
    }
    
    mutating func setStations(_ stations: [SBStation]) {
        self.stations = stations
    }
    
    mutating func addStations(_ stations: SBStation...) {
        self.stations.append(contentsOf: stations)
    }
    
    mutating func removeStations(at offsets: IndexSet...) {
        offsets.forEach { offset in
            stations.remove(atOffsets: offset)
        }
    }
    
    mutating func insertStations(_ stations: [SBStation]) {
        stations.forEach { station in
            self.stations.insert(station, at: 0)
        }
    }
}
