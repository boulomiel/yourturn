//
//  SBHourShift.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SBHistory
import SwiftData
import SwiftUI


struct SBHourShift: View {
    
    @Environment(\.dismiss) var dismiss
    @State var obs: SBHourShiftObs
    @State var selectedTeam: [String]?
    
    var body: some View {
        NavigationStack {
            VStack {
                tabs
            }
            .onAppear {
                obs.fetchDateList()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SBHourShiftPrincipalToolbar(shiftCase: $obs.shiftCase,
                                                shareLink: obs.shareLink,
                                                personCount: obs.persons.count, saveCurrentList: {
                        obs.saveCurrentList()
                        dismiss.callAsFunction()
                        
                    })
                }
                
                ToolbarItem(placement: .bottomPlatform) {
                    SBPopupView(state: obs.popupState)
                }
            }
        }
        .animation(.default, value: obs.persons)
        .animation(.bouncy, value: obs.shareLink)
    }
    
    @ViewBuilder
    var tabs: some View {
        TabView(selection: $obs.shiftCase) {
            SBTimeline(obs: obs)
                .tag(SBShiftCase.time)
            
            SBPersonList()
                .environment(obs)
                .tag(SBShiftCase.persons)
            
            SBStationView(shiftStore: $obs.shiftStore, popupState: $obs.popupState)
                .tag(SBShiftCase.stations)
        }
        .tabViewStyle(.automatic)
        .safeAreaPadding(.all)
    }
}

#Preview {
    let container = ShiftBeeApp.previewContainer
    let moc = container.mainContext
    SBHourShift(obs: .init(modelContainer: container, date: .now))
        .preferredColorScheme(.dark)
        .onAppear {
            let teamNames = ["Paul", "Jhon", "Flock", "Pouf", "Chocolate"]
            let team = SBTeam(name: "Team 1", team: teamNames.map { .init(name: $0) })
            
            moc.insert(team)
            
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
}

