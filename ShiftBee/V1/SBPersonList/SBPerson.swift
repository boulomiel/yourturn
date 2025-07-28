//
//  SBPerson.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import SBExtensions
import Foundation

struct SBPerson: Equatable, SBCSVConvertible, Identifiable {
    
    static var csvHeader: String {
        "Name,Time"
    }
    
    
    var csvRow: String {
        "\(name), \(period)"
    }
    
    var maxNameWidth: CGFloat {
        name.textWidth()
    }
    
    let id: UUID = .init()
    var name: String
    var time: Date?
    
    var period: String {
        time?.hoursAndMinutesPeriod ?? ""
    }
    
}

extension Array where Element == SBPerson {
    
    func generatePDF() -> URL? {
#if os(macOS)
        print("Could not create PDF", "MACOS")
        return nil
#else
        let date = Date.now.formatted(date: .abbreviated, time: .omitted)
        let fileName = "Shifts-\(date).pdf"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = path.appendingPathComponent(fileName)
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // A4 size
        let labelsAttributes: [NSAttributedString.Key: Any]? = [.font: PlatformFont.systemFont(ofSize: 14)]
        do {
            try renderer.writePDF(to: fileURL, withActions: { context in
                context.beginPage()
                
                let title = "Shifts - \(date)"
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: PlatformFont.boldSystemFont(ofSize: 20)
                ]
                title.draw(at: CGPoint(x: 72, y: 72), withAttributes: titleAttributes)
                
                var yPosition = 110
                
                // Calculate max width of all names for alignment
                let maxNameWidth = reduce(into: 0.0) { partialResult, convertible in
                    partialResult += convertible.maxNameWidth
                }
                
                let spacing: CGFloat = 20 // space between name and time column
                let timeX = 72 + maxNameWidth + spacing
                
                for person in self {
                    let namePoint = CGPoint(x: 72, y: CGFloat(yPosition))
                    let timePoint = CGPoint(x: timeX, y: CGFloat(yPosition))
                    
                    (person.name as NSString).draw(at: namePoint, withAttributes: labelsAttributes)
                    ("Time: \(person.period)" as NSString).draw(at: timePoint, withAttributes: labelsAttributes)
                    
                    yPosition += 24
                }
            })
            
            return fileURL
        } catch {
            print("Could not create PDF: \(error)")
            return nil
        }
#endif
    }
    
}

