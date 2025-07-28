//
//  SBCSVConvertible.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation

public protocol SBCSVConvertible {
    static var csvHeader: String { get }
    var csvRow: String { get }
    var maxNameWidth: CGFloat { get }
}
