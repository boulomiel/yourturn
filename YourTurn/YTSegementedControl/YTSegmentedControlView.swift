//
//  YTSegmentedControlView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftUI

struct YTSegmentedControlView<Case: YTSegmentValueCase>: View {
    
    @Namespace private var segmentSpace
    
    /// - Constructor
    let cases: [Case]
    @Binding var selectedCase: Case
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(cases, id: \.self) { value in
                Text(value.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .frame(minWidth: 80, minHeight: 35)
                    .background {
                        if selectedCase == value {
                            Capsule()
                                .fill(Color.white.gradient.opacity(0.3))
                                .overlay {
                                    Capsule()
                                        .stroke(lineWidth: 3)
                                        .foregroundStyle(Color.red.gradient.opacity(0.8))
                                }
                                .shadow(radius: 3)
                                .matchedGeometryEffect(id: "\(Case.self)", in: segmentSpace)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedCase = value
                        }
                    }
            }
        }
        .background {
            Capsule()
                .fill(Color.blue.gradient)
        }
        .safeAreaPadding(.horizontal)
    }
}



#Preview {
    @Previewable @State var selectedCase: YTShiftCase = .persons
    YTSegmentedControlView(cases: YTShiftCase.allCases, selectedCase: $selectedCase)
}
