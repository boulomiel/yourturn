//
//  SBStationView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 09/05/2025.
//

import SBHistory
import Foundation
import SwiftUI

struct SBStationView: View {

    let helper: SBStationListHelper = .init()
    @Binding var shiftStore: SBHourShiftStore
    @Binding var popupState:  SBPopupState<SBHourShiftInfo, SBHourShiftError>

    var body: some View {
        Form {
            Section {
                SBStationCell(stationName: "") { station  in
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

struct SBStationListHelper {
    
    func onAddingStation(name: String, in stations: [SBStation]) -> Result<[SBStation], SBNameError> {
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
    @Previewable @State var hourShiftObs = SBHourShiftObs(modelContainer: ShiftBeeApp.previewContainer, date: .now)
    SBStationView(shiftStore: $hourShiftObs.shiftStore, popupState: $hourShiftObs.popupState)
        .preferredColorScheme(.dark)
}
