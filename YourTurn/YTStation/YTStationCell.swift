//
//  YTStationCell.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 13/05/2025.
//

import SwiftUI

struct YTStationCell: View {
    
    @FocusState private var isFocused: Bool
    @State var stationName: String
    let onSubmit: (String) -> Void
    
    var body: some View {
        TextField("Station...", text: $stationName)
            .focused($isFocused)
            .onSubmit {
                isFocused = false
                onSubmit(stationName)
                stationName = ""
            }
            .onAppear {
                isFocused = true
            }
            .padding(4)
    }
}
