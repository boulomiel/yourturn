//
//  extension Binding.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftUI

extension Binding where Value: Sendable {
    func onChange(_ handler: @Sendable @MainActor @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                wrappedValue = newValue
                Task {
                    await MainActor.run {
                        handler(newValue)
                    }
                }
            }
        )
    }
}
