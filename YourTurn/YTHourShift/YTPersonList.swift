//
//  YTPersonList.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftUI

struct YTPersonList: View {
    
    @Environment(YTHourShiftObs.self) var hourShiftObs
    @State private var fetchCount: Int = 0
    @State private var sheetTeam: SheetTeam?
    @State private var selectedTeamName: String?
    
    var body: some View {
        Form {
            headerSection

            Section {
                YTPersonListView()
            } header: {
                Text("Members")
            }

        }
        .onChange(of: hourShiftObs.shiftStore, { oldValue, newValue in
            hourShiftObs.timePerPerson()
        })
        .onAppear {
            fetchTeamCount()
            hourShiftObs.timePerPerson()
        }
        .sheet(item: $sheetTeam, onDismiss: {
            fetchTeamCount()
        }, content: { _ in
            YTAddTeamView()
        })
        .tag(YTShiftCase.persons)
    }
    
    @ViewBuilder
    var headerSection: some View {
        if fetchCount > 0 {
            teamSelectionSection
        } else {
            addTeamSection
        }
    }
    
    var teamSelectionSection: some View {
        Section {
            NavigationLink {
                YTTeamListView { result in
                    selectedTeamName = result.team
                    hourShiftObs.shiftStore.setPersons(result.persons)
                }
            } label: {
                Text(selectedTeamName ?? "Teams list")
                    .fontWeight(.bold)
                    .fontWidth(.compressed)
                    .fontDesign(.rounded)
            }
        } header: {
            Text("Selection")
        }
    }
    
    var addTeamSection: some View {
        Section {
            Button {
                sheetTeam = .init()
            } label: {
                HStack {
                    Label("New team", systemImage: "person.3.fill")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.gray)
            }
            .buttonStyle(.plain)
        } header: {
            Text("No team found")
        }
    }
    
    private func fetchTeamCount() {
       // Task {
            fetchCount = hourShiftObs.fetchTeamCount()
       // }
    }
}

#Preview {
    @Previewable @State var hourshiftObs: YTHourShiftObs = .init(modelContainer: YourTurnApp.previewContainer, date: .now)
    YTPersonList()
        .environment(hourshiftObs)
        .preferredColorScheme(.dark)
}
