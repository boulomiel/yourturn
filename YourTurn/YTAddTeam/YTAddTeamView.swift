//
//  YTPersonListView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//


import SwiftUI
import Combine
import NaturalLanguage

struct YTAddTeamView: View {
    
    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dimiss
    @State private var teamName: String = ""
    
    // - Constructor
    @State var obs: YTAddTeanObs = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                YTTitleEditView(title: "New team...") { name in
                    teamName = name
                }
                .safeAreaPadding(.horizontal)
                Form {
                    Section {
                        ForEach(obs.cellObs, id: \.id) { cellOb in
                            YTSelectionNameCell(obs: cellOb)
                                .deleteDisabled(cellOb === obs.cellObs.first)
                        }
                        .onDelete { indexSet in
                            withAnimation(.easeInOut) {
                                obs.cellObs.remove(atOffsets: indexSet)
                            }
                        }
                    } header: {
                        Text("Team members")
                    }
                    
                }
            }
            .safeAreaPadding(.top)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    GeometryReader { geo in
                       saveTeamButton
                       YTPopupView(state: obs.popupState)
                    }
                    .frame(height: 55)
                }
            }
        }
        .onReceive(obs.getNameEvent, perform: { event in
            guard obs.nameError == .idle else { return }
            if case let .get(name: name) =  event {
                obs.cellObs[obs.cellObs.count-1].name = name
                obs.onAddingNameTapped()
            }
        })
        
    }
    
    @ViewBuilder
    var errorPopup: some View {
        GeometryReader { geo in
            let size = geo.size
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
                .frame(width: obs.nameError == .idle ? 0 : size.width * 0.8, height:  obs.nameError == .idle ? 0 : 60)
                .overlay {
                    Group {
                        switch obs.nameError {
                        case .idle:
                            EmptyView()
                        case .tooShort:
                            Text("Oops! The name is too short.")
                        case .emptyName:
                            Text("Oops! Can't add an empty name.")
                        case .nameAlreadyExists:
                            Text("Oops! This name is already in the list.")
                        }
                    }
                    .frame(width: obs.nameError == .idle ? 0 : size.width * 0.8, height: obs.nameError == .idle ? 0 : 60)
                    .opacity(obs.showTextError ? 1 : 0)
                }
                .position(x: size.width * 0.5, y: size.height * 0.5)
        }
        .frame(height: 60)
    }
    
    var saveTeamButton: some View {
        Button {
            let names = obs.cellObs.map(\.name).filter { !$0.isEmpty }
            let teamData = YTStorage.archiveStringArray(object: names)
            moc.insert(Team(name: teamName, teamData: teamData))
            do {
                try moc.save()
                dimiss.callAsFunction()
            } catch {
                print(error)
            }
        } label: {
            Image(systemName: "tray.and.arrow.down")
                .foregroundStyle(.blue)
        }
        .frame(width: 40, height: 40)
    }
}

#Preview {
    YTAddTeamView(obs: .init())
        .preferredColorScheme(.dark)
}
