//
//  YTHourShiftPrincipalToolbar.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 13/05/2025.
//

import SwiftUI

struct YTHourShiftPrincipalToolbar: View {
    
    @Binding var shiftCase : YTShiftCase
    let shareLink: URL?
    let personCount: Int
    let saveCurrentList: () -> Void
    
    var body: some View {
        HStack {
            YTSegmentedControlView(cases: YTShiftCase.allCases, selectedCase: $shiftCase)
            
            if personCount > 1 {
                Button {
                    saveCurrentList()
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.gradient.opacity(1.0))
                        .frame(width: 30, height: 30, alignment: .center)
                        .overlay {
                            Image(systemName: "tray.and.arrow.down")
                                .foregroundStyle(.white)
                        }
                }
                .transition(.scale)
            }
            
            if let fileURL = shareLink, personCount > 2 {
                ShareLink(item: fileURL) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.gradient.opacity(1.0))
                        .frame(width: 30, height: 30, alignment: .center)
                        .overlay {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.white)
                        }
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    @Previewable @State var shiftCase: YTShiftCase = .persons
    YTHourShiftPrincipalToolbar(shiftCase: $shiftCase, shareLink: URL(string: "wwww.google.com")!, personCount: 3) {}

    
}
