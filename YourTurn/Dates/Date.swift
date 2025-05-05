//
//  Date.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import Foundation

extension Date {
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
}
