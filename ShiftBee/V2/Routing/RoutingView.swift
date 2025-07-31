//
//  RoutingView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

typealias BaseRouter = Router<NavigationSheet, NavigationPopover>

struct RoutingView<Navigator, RootView>: View where Navigator: BaseRouter, RootView: View {
    
    @State private var navigator: Navigator
    @ViewBuilder var rootView: RootView
    
    init(navigator: Navigator,
         @ViewBuilder rootView: @escaping () -> RootView) {
        self.navigator = navigator
        self.rootView = rootView()
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path,root: {
            rootView
                .navigationDestination(for: NavigationRoute.self) { item in
                    item.view
                }
        })
        .sheet(item: $navigator.sheetItem, onDismiss: navigator.sheetItem?.onDismiss) { item in
            item.view
        }
        .popover(item: $navigator.popoverItem) { item in
            item.view
        }
    }
}


#Preview {
    @Previewable @State var router: BaseRouter = .init()
    
    RoutingView(navigator: router, rootView: {
        List {
            Button("Sheet") {
                router.presentSheet(.testSheet)
            }
            
            Button("Popover") {
                router.presentPopover(.testPopover)
            }
            
            Button("Push") {
                router.push(NavigationRoute.testPush)
            }
        }
        .navigationTitle("Routing view")
    })
}

