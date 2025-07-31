//
//  SBTeamListView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SBExtensions
import SBHistory
import SwiftData
import SwiftUI

struct SBTeamSelect {
    let team: String
    let persons: [SBPerson]
}

struct SBTeamListView: View {
    
    @Query(sort: \SBTeam.name) private var teams: [SBTeam]
    @Environment(\.dismiss) private var dismiss
    @State private var addTeamSheet: SheetTeam?

    let teamMembersSelected: (SBTeamSelect) -> Void
    
    var body: some View {
        VStack {
            ForEach(teams, id: \.name) { team in
                SBDisclosureGroup(cellTitle: team.name, cellList: team.team.map(\.name)) { result in
                    var teamNames = result.cellList.map { SBPerson(name: $0) }
                    teamNames.shuffle()
                    teamMembersSelected(.init(team: result.cellTitle, persons: teamNames))
                    dismiss.callAsFunction()
                }
            }
            Spacer()
        }
        .safeAreaPadding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailingPlatform) {
                Button {
                    addTeamSheet = .init()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.gradient)
                        .frame(width: 30, height: 30)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                }

            }
        }
        .sheet(item: $addTeamSheet) { _ in
            SBAddTeamView(obs: .init())
        }
    }
}


#Preview {
    let container = ShiftBeeApp.previewContainer
    let moc = container.mainContext
    let teamNames = ["Paul", "Jhon", "Flock", "Pouf", "Chocolate"]
    let team = SBTeam(name: "Team 1", team: teamNames.map { .init(name: $0) })
    
    moc.insert(team)
    
    let team2 = SBTeam(name: "Team 2",  team: teamNames.map { .init(name: $0) })
    
    moc.insert(team2)
    
    try! moc.save()
    
     return NavigationStack {
        SBTeamListView(teamMembersSelected: { _ in })
            .modelContainer(container)
            .preferredColorScheme(.dark)
            .navigationDestination(for: SheetTeam.self) { _ in
                SBAddTeamView(obs: .init())
            }
    }
    
}
