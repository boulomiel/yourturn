//
//  YTCSVConverter.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation
import UIKit

struct YTCSVConverter {
    
    func createCSVFile<T: YTCSVConvertible>(from items: [T]) -> URL? {
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
    
    func generateCSV<T: YTCSVConvertible>(from items: [T]) -> String {
        let header = T.csvHeader
        let rows = items.map { $0.csvRow }
        return ([header] + rows).joined(separator: "\n")
    }
    
    func generatePDF(from people: [YTPerson]) -> URL? {
        let date = Date.now.formatted(date: .abbreviated, time: .omitted)
        let fileName = "Shifts-\(date).pdf"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = path.appendingPathComponent(fileName)

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // A4 size

        do {
            try renderer.writePDF(to: fileURL, withActions: { context in
                    context.beginPage()

                    let title = "Shifts - \(date)"
                    let titleAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 20)
                    ]
                    title.draw(at: CGPoint(x: 72, y: 72), withAttributes: titleAttributes)

                    let nameFont = UIFont.systemFont(ofSize: 14)
                    let labelAttributes: [NSAttributedString.Key: Any] = [.font: nameFont]
                    var yPosition = 110

                    // Calculate max width of all names for alignment
                    let maxNameWidth = people
                        .map { ($0.name as NSString).size(withAttributes: labelAttributes).width }
                        .max() ?? 0

                    let spacing: CGFloat = 20 // space between name and time column
                    let timeX = 72 + maxNameWidth + spacing

                    for person in people {
                        let namePoint = CGPoint(x: 72, y: CGFloat(yPosition))
                        let timePoint = CGPoint(x: timeX, y: CGFloat(yPosition))

                        (person.name as NSString).draw(at: namePoint, withAttributes: labelAttributes)
                        ("Time: \(person.period)" as NSString).draw(at: timePoint, withAttributes: labelAttributes)

                        yPosition += 24
                    }
                })

            return fileURL
        } catch {
            print("Could not create PDF: \(error)")
            return nil
        }
    }
}
