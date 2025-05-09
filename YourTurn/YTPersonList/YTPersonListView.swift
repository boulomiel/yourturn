//
//  YTPersonListView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftUI
import Combine
import NaturalLanguage

struct YTPersonListView: View {
    
    
    @Environment(\.dismiss) var dimiss
    @AppStorage("lastList") var lastList: Data?
    
    let obs: YTPeronListObs
    let onPersonAdded: ([YTPerson]) -> Void
    
    var body: some View {
        List {
            ForEach(obs.cellObs, id: \.id) { cellOb in
                YTSelectionNameCell(obs: cellOb)
                    .deleteDisabled(obs.cellObs.count < 2 || cellOb === obs.cellObs.last)
            }
            .onDelete { indexSet in
                obs.cellObs.remove(atOffsets: indexSet)
                withAnimation(.easeInOut) {
                    onPersonAdded(obs.cellObs.map { YTPerson(name: $0.name, time: $0.time) }.filter { !$0.name.isEmpty })
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
        }
        .onReceive(obs.getNameEvent, perform: { event in
            guard obs.nameError == .idle else { return }
            if case let .get(name: name) =  event {
                obs.cellObs[obs.cellObs.count-1].name = name
                obs.onAddingNameTapped()
                withAnimation(.easeInOut) {
                    onPersonAdded(obs.cellObs.map { YTPerson(name: $0.name, time: $0.time) }.filter { !$0.name.isEmpty })
                }
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
}

#Preview {
    YTPersonListView(obs: .init(person: [])) { _ in }
        .preferredColorScheme(.dark)
}
