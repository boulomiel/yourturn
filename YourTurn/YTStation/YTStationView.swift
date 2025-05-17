//
//  YTLocationView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 09/05/2025.
//

import Foundation
import SwiftUI

struct YTStationView: View {

    let helper: YTStationListHelper = .init()
    @Binding var shiftStore: YTHourShiftStore
    @Binding var popupState:  YTPopupState<YTHourShiftInfo, YTHourShiftError>

    var body: some View {
        Form {
            Section {
                YTStationCell(stationName: "") { station  in
                    withAnimation {
                        let result = helper.onAddingStation(name: station, in: shiftStore.stations)
                        switch result {
                        case .success(let success):
                            shiftStore.setStations(success)
                        case .failure(let failure):
                            popupState = .error(error: .nameErrors(failure))
                        }
                    }
                }
                ForEach(shiftStore.stations.reversed(), id: \.id) { station in
                    Text(station.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body)
                        .fontWeight(.semibold)
                        .fontWidth(.condensed)
                        .fontDesign(.rounded)
                }
                .onDelete { offset in
                    shiftStore.removeStations(at: offset)
                }
            } header: {
                Text("Stations")
            }
        }
    }
}

struct YTStationListHelper {
    
    func onAddingStation(name: String, in stations: [YTStation]) -> Result<[YTStation], YTNameError> {
        var copy = stations
        if stations.contains(where: { $0.name == name }) {
            return .failure(.nameAlreadyExists)
        }
        if name.count < 2 {
            return .failure(.tooShort)
        }
        copy.append(.init(name: name))
        return .success(copy)
    }
}


#Preview {
    @Previewable @State var hourShiftObs = YTHourShiftObs(modelContainer: YourTurnApp.previewContainer, date: .now)
    YTStationView(shiftStore: $hourShiftObs.shiftStore, popupState: $hourShiftObs.popupState)
        .preferredColorScheme(.dark)
}
