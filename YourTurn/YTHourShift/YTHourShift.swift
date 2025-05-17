//
//  YTHourShift.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftData
import SwiftUI


struct YTHourShift: View {
    
    @Environment(\.dismiss) var dismiss
    @State var obs: YTHourShiftObs
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
                    YTHourShiftPrincipalToolbar(shiftCase: $obs.shiftCase,
                                                shareLink: obs.shareLink,
                                                personCount: obs.persons.count, saveCurrentList: {
                        obs.saveCurrentList()
                        dismiss.callAsFunction()
                        
                    })
                }
                
                ToolbarItem(placement: .bottomBar) {
                    YTPopupView(state: obs.popupState)
                }
            }
        }
        .animation(.default, value: obs.persons)
        .animation(.bouncy, value: obs.shareLink)
    }
    
    @ViewBuilder
    var tabs: some View {
        TabView(selection: $obs.shiftCase) {
            YTTimeline(obs: obs)
                .tag(YTShiftCase.time)
            
            YTPersonList()
                .environment(obs)
                .tag(YTShiftCase.persons)
            
            YTStationView(shiftStore: $obs.shiftStore, popupState: $obs.popupState)
                .tag(YTShiftCase.stations)
        }
        .tabViewStyle(.automatic)
        .safeAreaPadding(.all)
    }
}

#Preview {
    let container = YourTurnApp.previewContainer
    let moc = container.mainContext
    YTHourShift(obs: .init(modelContainer: container, date: .now))
        .preferredColorScheme(.dark)
        .onAppear {
            let teamNames = ["Paul", "Jhon", "Flock", "Pouf", "Chocolate"]
            let team = Team(name: "Team 1", teamData: YTStorage.archiveStringArray(object: teamNames))
            
            moc.insert(team)
            
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
}
