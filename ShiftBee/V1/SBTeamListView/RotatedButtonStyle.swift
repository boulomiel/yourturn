//
//  RotatedButtonStyle.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftUI

struct RotatedButtonStyle: PrimitiveButtonStyle {
    
    @State var isOpened: Bool = false
    @State var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration
            .label
            .scaleEffect(isPressed ? 0.8 : 1.0)
            .rotationEffect(.degrees(isOpened ? 90 : 0))
            .onLongPressGesture(minimumDuration: 0, perform: {
                withAnimation {
                    isOpened.toggle()
                }
                configuration.trigger()
            }, onPressingChanged: { isPressing in
                withAnimation {
                    isPressed = isPressing
                }
            })
            .onTapGesture {
                configuration.trigger()
            }
    }
}
