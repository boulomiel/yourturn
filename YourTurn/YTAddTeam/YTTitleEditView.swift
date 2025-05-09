//
//  TitleEditView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 06/05/2025.
//

import SwiftUI

struct YTTitleEditView: View {
    
    enum InputState {
        case idle
        case input
        case save
        
        mutating func toggle(onFinish: @escaping (InputState) -> Void = { _ in }) {
            switch self {
            case .idle:
                self = .input
            case .input:
                self = .save
                onFinish(self)
            case .save:
                self = .idle
            }
        }
        
        var imageButton: String {
            switch self {
            case .idle:
                "square.and.pencil"
            case .input:
                "checkmark.circle"
            case .save:
                "checkmark.circle.fill"
            }
        }
    }
    
    @State private var inputState: InputState = .idle
    @FocusState private var isFocus: Bool
    
    @State var title: String = "Hello"
    let onSave: (String) -> Void
    
    var body: some View {
        HStack {
            inputContent
            Button {
                onSaveTitle()
            } label: {
                Image(systemName: inputState.imageButton)
            }
            .onSubmit {
                onSaveTitle()
            }
            .onChange(of: isFocus, { oldValue, newValue in
                if !newValue {
                    onSaveTitle()
                }
            })
            .onChange(of: inputState, { oldValue, newValue in
                if newValue == .input {
                    isFocus = true
                }
            })
            .frame(width: 40, height: 40)
            .contentShape(Rectangle())
            .symbolEffect(.bounce, value: inputState)
            
        }
    }
    
    private var inputContent: some View {
        Group {
            switch inputState {
            case .idle, .save:
                Text(title)
                    .foregroundStyle(Color.gray.opacity(0.5))
            case .input:
                TextField("",text: $title)
                    .focused($isFocus)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.gradient)
                            .opacity(0.2)
                    }
                    .foregroundStyle(Color.blue.opacity(0.6))
            }
        }
        .font(.largeTitle)
        .fontWeight(.bold)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)
        .saveAnimation(inputState == .save)
    }
    
    func onSaveTitle() {
        withAnimation {
            inputState.toggle { state in
                onSave(title)
                if case .save = state {
                    Task {
                        try? await Task.sleep(for: .milliseconds(700))
                        inputState.toggle()
                    }
                }
            }
        }
    }
}


extension View {
    
    func saveAnimation(_ animate: Bool) -> some View {
        modifier(SaveOverlayModifier(animate: animate))
    }
}

struct SaveOverlayModifier: ViewModifier {
    
    let animate: Bool
    @State private var start: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    if animate {
                        GeometryReader { geo in
                            let size = geo.size
                            Rectangle()
                                .fill(.white.gradient)
                                .rotationEffect(.degrees(45))
                                .blur(radius: 12)
                                .opacity(animate ? 0.7: 0.0)
                                .position(x: start ? size.width : 0, y: size.height / 2)
                                .frame(width: 25, height: 40)
                        }
                        .onAppear {
                            withAnimation(.smooth(duration: 0.3).delay(0.3)) {
                                start = true
                            }
                        }
                        .onDisappear {
                            withAnimation(.easeOut.delay(0.8)) {
                                start = false
                            }
                        }
                    }
                }
            }
            .background {
                if start {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.gradient)
                        .opacity(start ? 0.4: 0.0)
                }
            }
    }
    
}

#Preview {
    YTTitleEditView(onSave: { _ in })
        .preferredColorScheme(.dark)
}
