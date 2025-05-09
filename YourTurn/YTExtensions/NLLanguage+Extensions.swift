//
//  NLLanguage+Extensions.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//

import NaturalLanguage

extension NLLanguage {
    var isRightToLeft: Bool {
        switch self {
        case .hebrew, .arabic, .persian, .urdu:
            true
        default:
            false
        }
    }
}
