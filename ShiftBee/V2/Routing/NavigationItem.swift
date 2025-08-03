//
//  NavigationItem.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 31/07/2025.
//

import Foundation
import Playgrounds
import SwiftUI

protocol NavigationItem: Identifiable, Hashable {
    associatedtype Content: View
    var view: Content { get }
    var onDismiss: (() -> Void)? { get }
}

extension NavigationItem {
    
    var id: String {
        String(describing: self)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct TestView: View {
    
    var body: some View {
        Text("TestView")
    }
}

enum Bla: @MainActor NavigationItem {

    case bla
    case casa
    case polo(blanca: Binding<String>)
    
    var view: some View {
        Text("Bla")
    }
    
    var onDismiss: (() -> Void)? {
        nil
    }
}

#Playground {
    let bla = Bla.polo(blanca: .constant("Hello"))
    _ = bla.id
}
