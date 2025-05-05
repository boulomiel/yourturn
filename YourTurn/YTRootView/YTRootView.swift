//
//  YTRootView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftUI

enum Pages {
    case date
    case time
}

struct YTRootView: View {

    @State var obs: YTRootObs = .init()
    
    var body: some View {
        TabView(selection: $obs.selectedPage) {
            
            YTCalendarPicker()
                .tag(Pages.date)
            
            Text("Hours")
                .tag(Pages.time)
            
        }
        .preferredColorScheme(.dark)
    }
}

@Observable
class YTRootObs {
    
    var selectedPage: Pages = .date
    
}

#Preview {
    YTRootView()
}
