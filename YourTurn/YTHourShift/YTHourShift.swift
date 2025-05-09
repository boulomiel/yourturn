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
                    HStack {
                        YTSegmentedControlView(cases: YTShiftCase.allCases, selectedCase: $obs.shiftCase)
                        
                        if obs.persons.count > 1 {
                            Spacer()
                            Button {
                                obs.saveCurrentList()
                                dismiss.callAsFunction()
                            } label: {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.gradient.opacity(1.0))
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .overlay {
                                        Image(systemName: "tray.and.arrow.down")
                                            .foregroundStyle(.white)
                                    }
                            }
                            .transition(.scale)
                        }
                        
                        if let fileURL = obs.shareLink, obs.persons.count > 1 {
                            ShareLink(item: fileURL) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.gradient.opacity(1.0))
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .overlay {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundStyle(.white)
                                    }
                            }
                            .transition(.move(edge: .trailing))
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    YTPopupView(state: obs.popupState)
                }
            }
        }
    }
    
    @ViewBuilder
    var tabs: some View {
        TabView(selection: $obs.shiftCase) {
            YTTimeline(obs: obs)
                .tag(YTShiftCase.time)
            
            YTPersonList(obs: obs)
                .tag(YTShiftCase.persons)
        }
        .tabViewStyle(.automatic)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var moc
    
    YTHourShift(obs: .init(modelContainer: moc.container, date: .now))
        .preferredColorScheme(.dark)
        .onAppear {
            let teamNames = ["Paul", "Jhon", "Flock", "Pouf", "Chocolate"]
            let team = Team(name: "Team 1", teamData: YTStorage.archiveStringArray(object: teamNames))
            
            moc.insert(team)
            
            try! moc.save()
        }
}
