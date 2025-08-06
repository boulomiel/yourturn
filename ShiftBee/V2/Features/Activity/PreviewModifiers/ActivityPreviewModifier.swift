//
//  ActivityPreviewModifier.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import SwiftUI
import SwiftData

struct ActivityPreviewModifier: PreviewModifier {    
    
    static let history = Preview().history
    static let container = Preview().modelContainer
    @State var router: NewActivityRouter = .init()
 
    static func makeSharedContext() async throws -> ModelContainer {
        container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        RoutingView(navigator: router, rootView: {
            content
        })
        .environment(ShiftBeeLocationManager())
        .modelContainer(context)
    }
}
