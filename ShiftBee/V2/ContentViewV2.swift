//
//  ContentViewV2.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

struct ContentViewV2: View {
    
    let floatingActionHandler: FloattingButtonActionHandler = .init()
    
    var body: some View {
        WeekScrollCalendarView()
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                FloatingButton {
                    FloatingButtonItem(
                        label: "Add Event",
                        systemImage: "calendar.badge.plus",
                        action: {
                            // Code to add a new event
                        }
                    )
                    
                    FloatingButtonItem(
                        label: "Today",
                        systemImage: "calendar",
                        action: {
                            floatingActionHandler.onJumpToToDay()
                            // Code to jump to today's date
                        }
                    )
                    
                    FloatingButtonItem(
                        label: "Calendars",
                        systemImage: "list.bullet",
                        action: {
                            floatingActionHandler.onShowCalendarList()
                            // Code to show calendar list
                        }
                    )
                }
                .padding(.horizontal, 8)
            }
            .environment(floatingActionHandler)
        
    }
}

@Observable
class FloattingButtonActionHandler {

    var onJumpToToDay: () -> Void = {}
    var onShowCalendarList: () -> Void =  {}
}


#Preview {
   // ContentViewV2()
    //@Previewable @State var router: Router = .init()
    
//    RoutingView(router: router, root: {
//        List {
//            Button("Sheet") {
//                router.presentSheet(TestSheetData())
//            }
//            
//            Button("Popover") {
//                
//            }
//            
//            Button("Push") {
//                
//            }
//        }
//        .navigationTitle("Routing view")
//    })
}

