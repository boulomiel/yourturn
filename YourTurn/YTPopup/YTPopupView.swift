//
//  YTErrorPopupView.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftUI

struct YTPopupView<Info: YTInfoPopupProtocol, Error: YTErrorPopupProtocol>: View {
    
    let state: YTPopupState<Info, Error>
    
    @Namespace var pickerSpace
    
    var body: some View {
        GeometryReader { geo in
            switch state {
            case .error(error: let value):
                Capsule()
                    .fill(Color.red.gradient)
                    .overlay {
                        Text(value.localizedDescription)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.8)
                            .lineLimit(5)
                            .layoutPriority(1)
                            .multilineTextAlignment(.center)
                            .frame(width: 280, alignment: .center)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .matchedGeometryEffect(
                        id: "error",
                        in: pickerSpace,
                        properties: .size,
                        anchor: .center,
                        isSource: false
                    )
                    .frame(width: 300, height: 50)
            case .info(info: let info):
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .overlay {
                        Text(info.localizedDescription)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.8)
                            .lineLimit(5)
                            .layoutPriority(1)
                            .multilineTextAlignment(.center)
                            .frame(width: 280, alignment: .center)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .matchedGeometryEffect(id: "error", in: pickerSpace, anchor: .center, isSource: true)
                    .frame(width: 300, height: 50)
            default:
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .matchedGeometryEffect(id: "error", in: pickerSpace, anchor: .center, isSource: true)
                    .frame(width: 80, height: 30)
            }
        }
        .frame(height: 50)
    }
}
