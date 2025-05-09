//
//  NameErrors.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//

enum NameErrors: YTErrorPopupProtocol {
    var localizedDescription: String {
        switch self {
        case .idle:
            ""
        case .emptyName:
            "An empty name is not allowed."
        case .tooShort:
            "The name must be at least 2 characters long."
        case .nameAlreadyExists:
            "The name already exists."
        }
    }
    
    case idle
    case emptyName
    case tooShort
    case nameAlreadyExists
}
