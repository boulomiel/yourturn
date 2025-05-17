//
//  YTHourShiftStore.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 13/05/2025.
//

import Foundation

struct YTHourShiftStore: Equatable {
    private(set) var persons: [YTPerson]
    private(set) var stations: [YTStation]
    
    init(persons: [YTPerson], stations: [YTStation]) {
        self.persons = persons
        self.stations = stations
    }
    
    mutating func setPersons(_ persons: [YTPerson]) {
        self.persons = persons
    }
    
    mutating func addPersons(_ persons: YTPerson...) {
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
    
    mutating func setStations(_ stations: [YTStation]) {
        self.stations = stations
    }
    
    mutating func addStations(_ stations: YTStation...) {
        self.stations.append(contentsOf: stations)
    }
    
    mutating func removeStations(at offsets: IndexSet...) {
        offsets.forEach { offset in
            stations.remove(atOffsets: offset)
        }
    }
    
    mutating func insertStations(_ stations: [YTStation]) {
        stations.forEach { station in
            self.stations.insert(station, at: 0)
        }
    }
}
