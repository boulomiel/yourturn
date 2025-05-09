//
//  YTPersonList.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftUI

struct YTPersonList: View {
    
    @Bindable var obs: YTHourShiftObs
    @State private var fetchCount: Int = 0
    @State private var sheetTeam: SheetTeam?
    @State private var selectedTeamName: String?
    
    var body: some View {
        Form {
            headerSection

            Section {
                YTPersonListView(obs:.init(person: obs.persons)) { names in
                    obs.persons = names
                }
            } header: {
                Text("Members")
            }

        }
        .onChange(of: obs.persons, { oldValue, newValue in
            obs.timePerPerson()
        })
        .onAppear {
            fetchTeamCount()
            obs.timePerPerson()
        }
        .sheet(item: $sheetTeam, onDismiss: {
            fetchTeamCount()
        }, content: { _ in
            YTAddTeamView(obs: .init())
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
                    obs.persons = result.persons
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
            fetchCount = obs.fetchTeamCount()
       // }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var moc
    YTPersonList(obs: .init(modelContainer: moc.container, date: .now))
        .preferredColorScheme(.dark)
}
