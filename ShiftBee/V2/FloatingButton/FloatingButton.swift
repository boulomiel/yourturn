//
//  FloatingButton.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI

struct FloatingButtonItem: Identifiable {
    
    let id: UUID = .init()
    let label: String
    let systemImage: String
    let action: () -> Void
    
}

@resultBuilder
struct FloatingButtonItemBuilder {
    static func buildBlock(_ components: FloatingButtonItem...) -> [FloatingButtonItem] {
        components.compactMap { $0 }
    }
}

struct FloatingButton: View {
    
    @State private var showFloatingItems: Bool = false
    @Namespace private var liquidTransition
    
    var buttonsColor: Color
    var buttonsDiameter: CGFloat
    var items: [FloatingButtonItem]
    
    private var radius: CGFloat {
        buttonsDiameter * 2
    }
    
    private var startButtonFloatingItem: FloatingButtonItem {
        .init(label: "Mode", systemImage: "plus") {
            showFloatingItems.toggle()
        }
    }
    
    init(@FloatingButtonItemBuilder items: @escaping () -> [FloatingButtonItem],
         buttonsColor: Color = .blue,
         buttonsDiameter: CGFloat = 50) {
        self.items = items()
        self.buttonsColor = buttonsColor
        self.buttonsDiameter = buttonsDiameter
    }
    
    var body: some View {
        GlassEffectContainer() {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let angle = .pi + CGFloat(index) * .pi / 4
                FloattingItem(item, showShadow: showFloatingItems)
                    .offset(
                        x: showFloatingItems ? radius * cos(angle) : 0,
                        y: showFloatingItems ? radius * sin(angle) : 0
                    )
                    .glassEffectTransition(.matchedGeometry)
                    .animation(.snappy.delay(CGFloat(index) * 0.1), value: showFloatingItems)
            }
            
            FloattingItem(startButtonFloatingItem, tint: .orange, showShadow: true)
        }
        .sensoryFeedback(.increase, trigger: showFloatingItems)
    }
    
    func FloattingItem(_ item: FloatingButtonItem, tint: Color = .red, showShadow: Bool = false) -> some View {
        Button {
            item.action()
        } label: {
            Image(systemName: item.systemImage)
                .font(.system(size: 32))
                .frame(width: 50, height: 50)
                .background(Circle().fill(buttonsColor.gradient))
                .foregroundColor(.white)
                .shadow(color: showShadow ? .white.opacity(0.3) : .clear, radius: 8, x: -4, y: -2)

        }
        .glassEffect(.regular.interactive().tint(tint))
    }
}

#Preview {
    
    ZStack {
        Color.black
        FloatingButton {
            FloatingButtonItem(
                label: "Add Event",
                systemImage: "calendar.badge.plus",
                action: {
                    // Code to add a new event
                }
            )
            
            FloatingButtonItem(
                label: "Today",
                systemImage: "calendar",
                action: {
                    // Code to jump to today's date
                }
            )
            
            FloatingButtonItem(
                label: "Calendars",
                systemImage: "list.bullet",
                action: {
                    // Code to show calendar list
                }
            )
        }
    }
}
