//
//  YTDisclosureGroup.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftUI

struct YTDisclosureSelect {
    let cellTitle: String
    let cellList: [String]
}

struct YTDisclosureGroup: View {
    typealias Cell = String
    let cellTitle: String
    let cellList: [Cell]
    let onListSelected: (YTDisclosureSelect) -> Void
    let cellSpace: CGFloat = 2
    
    @Namespace private var groupSpace
    @State private var openList: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                closedList
                if openList {
                    VStack(spacing: cellSpace) {
                        ForEach(cellList, id: \.self) { item in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Material.thinMaterial)
                                .frame(height: 45)
                                .overlay(alignment: .leading) {
                                    Text("\(item)")
                                        .padding(.leading, 12)
                                }
                        }
                    }
                }
            }
        }
        .frame(height: groupHeight)
    }
    
    var groupHeight: CGFloat {
        openList ? CGFloat(cellList.count) * 45 + 2 * CGFloat(cellList.count) : 45
    }
    
    var closedList: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Material.thinMaterial)
            .frame(height: 45)
            .overlay(alignment: .leading) {
                Text(cellTitle)
                    .padding(.leading, 8)
            }
            .overlay(alignment: .trailing) {
                HStack {
                    Button {
                        onListSelected(.init(cellTitle: cellTitle, cellList: cellList))
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.white)
                            }
                        
                    }
                    
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            openList.toggle()
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.gradient)
                            .frame(width: 30, height: 30)
                            .overlay {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                            }
                    }
                    .buttonStyle(RotatedButtonStyle())
                }
            }
    }
}

#Preview {
    YTDisclosureGroup(cellTitle: "Hello", cellList: ["Jhon", "Phil", "Plo", "Mary"]) { _  in }
        .preferredColorScheme(.dark)
    
}
