//
//  YTCSVConvertible.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation

protocol YTCSVConvertible {
    static var csvHeader: String { get }
    var csvRow: String { get }
}
