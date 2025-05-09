//
//  YTTeamListView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftData
import SwiftUI

struct YTTeamSelect {
    let team: String
    let persons: [YTPerson]
}

struct YTTeamListView: View {
    
    @Query(sort: \Team.name) private var teams: [Team]
    @Environment(\.dismiss) private var dismiss
    @State private var addTeamSheet: SheetTeam?

    let teamMembersSelected: (YTTeamSelect) -> Void
    
    var body: some View {
        VStack {
            ForEach(teams, id: \.name) { team in
                YTDisclosureGroup(cellTitle: team.name, cellList: team.team) { result in
                    var teamNames = result.cellList.map { YTPerson(name: $0) }
                    teamNames.shuffle()
                    teamMembersSelected(.init(team: result.cellTitle, persons: teamNames))
                    dismiss.callAsFunction()
                }
            }
            Spacer()
        }
        .safeAreaPadding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
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
            YTAddTeamView(obs: .init())
        }
    }
}


#Preview {
    let container = YourTurnApp.previewContainer
    let moc = container.mainContext
    let teamNames = ["Paul", "Jhon", "Flock", "Pouf", "Chocolate"]
    let team = Team(name: "Team 1", teamData: YTStorage.archiveStringArray(object: teamNames))
    
    moc.insert(team)
    
    let team2 = Team(name: "Team 2", teamData: YTStorage.archiveStringArray(object: teamNames))
    
    moc.insert(team2)
    
    try! moc.save()
    
    return NavigationStack {
        YTTeamListView(teamMembersSelected: { _ in })
            .modelContainer(container)
            .preferredColorScheme(.dark)
            .navigationDestination(for: SheetTeam.self) { _ in
                YTAddTeamView(obs: .init())
            }
    }
    
}
