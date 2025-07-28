//
//  SBCSVConverter.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation

public struct SBCSVConverter {
    
    public init() {}
    
    public func createCSVFile<T: SBCSVConvertible>(from items: [T]) -> URL? {
        let fileName = "data.csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = path.appendingPathComponent(fileName)
        
        let csvString = generateCSV(from: items)
        
        print(csvString)

        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Failed to create file: \(error)")
            return nil
        }
    }
    
    public func generateCSV<T: SBCSVConvertible>(from items: [T]) -> String {
        let header = T.csvHeader
        let rows = items.map { $0.csvRow }
        return ([header] + rows).joined(separator: "\n")
    }
    
}

