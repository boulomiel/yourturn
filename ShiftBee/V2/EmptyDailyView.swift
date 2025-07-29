//
//  EmptyDailyView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import SwiftUI

struct EmptyDailyView: View {
    
    @Namespace private var emptyTaskUnion

    var body: some View {
        GlassEffectContainer(spacing: 50) {
            Image(systemName: "beach.umbrella")
                .font(.system(size: 120))
                .foregroundStyle(.blue.gradient)
                .glassEffect(.regular.interactive())
                .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "cup.and.heat.waves.fill")
                        .font(.system(size: 40))
                        .padding(8)
                        .foregroundStyle(.blue.gradient)
                        .glassEffect(.regular.interactive())
                        .offset(x: -50)
                        .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                    
                }
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "books.vertical")
                        .font(.system(size: 30))
                        .padding(8)
                        .foregroundStyle(.blue.gradient)
                        .glassEffect(.regular.interactive())
                        .offset(x: 30 ,y: -30)
                        .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                    
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "gamecontroller")
                        .font(.system(size: 30))
                        .padding(8)
                        .foregroundStyle(.blue.gradient)
                        .glassEffect(.regular.interactive())
                        .offset(x: 40 ,y: 20)
                        .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                        .overlay(alignment: .bottomLeading) {
                            Text("Nothing Scheduled")
                                .font(.system(size: 22).bold())
                                .foregroundStyle(.blue.gradient)
                                .fixedSize(horizontal: true, vertical: true)
                                .padding(12)
                                .glassEffect(.regular.interactive())
                                .offset(x: -120 ,y: 65)
                                .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                        }
                }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    EmptyDailyView()
}
