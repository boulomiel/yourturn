//
//  SBCalendarPicker.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftUI

struct SBCalendarPicker: View {
    
    @Environment(\.modelContext) private var moc
    
    @State private var obs: SBCalendarPickerObs = .init()
    @State private var sheetDate: SheetDate?
    @State private var sheetTeam: SheetTeam?
    @State private var teamPersons: [SBPerson] = []
    @Namespace private var pickerSpace
    
    // Constructor
    @State var selectionObs: SBCalendarSelectionObs
    
    
    init(selectionObs: SBCalendarSelectionObs) {
        self.selectionObs = selectionObs
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(obs.monthName)
                .padding(.top, 40)
                .overlay(alignment: .bottom) {
                    SBPopupView(state: selectionObs.calendarPopup)
                }
                .toolbar(content: calendarToolBar)
                .sheet(item: $sheetDate) {
                    selectionObs.firstDate = nil
                    Task {
                        await selectionObs.fetchCount()
                    }
                } content: { sheet in
                    SBHourShift(obs: .init(modelContainer: moc.container, date: sheet.date))
                }
                .sheet(item: $sheetTeam, content: { _ in
                    SBAddTeamView(obs: .init())
                })
                .task {
                    await selectionObs.fetchCount()
                }
        }
    }
    
    var content: some View {
        VStack(spacing: 40) {
            GeometryReader { geo in
                let size = geo.size
                if !obs.weeks.isEmpty {
                    calendarGridView(size: size)
                }
            }
        }
    }
    
    @ViewBuilder
    func calendarGridView(size: CGSize) -> some View {
        let maxSize = size.width * 0.8
        let cellSize = maxSize / 7
        LazyVGrid(columns: Array(repeating: .init(.fixed(cellSize)), count: 7)) {
            ForEach(0..<7, id: \.self) { index in
                if obs.weeks.indices.contains(index) {
                    ForEach(obs.weeks[index], id: \.self) { date in
                        SBCalendarCell(cellDate: date, startMonthDate: obs.startMonthDate, size: cellSize, selectedObs: selectionObs) { date in
                            selectionObs.handleSelectedDate(at: index, with: date)
                            sheetDate = .init(date: date)
                        }
                    }
                }
            }
            
        }
    }
    
    @ToolbarContentBuilder
    func calendarToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                self.sheetTeam = .init()
            } label: {
                VStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.gradient.opacity(1.0))
                        .frame(width: 30, height: 30, alignment: .center)
                        .overlay {
                            VStack {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                            }
                        }
                    
                    Text("Team")
                        .font(.body)
                        .fontWidth(.condensed)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                
            }
        }
    }
    
    
    //    @ViewBuilder
    //    var sendAllButton: some View {
    //        if selectionObs.count > 0 {
    //            HStack {
    //                Spacer()
    //                Button {
    //
    //                } label: {
    //                    Label("Send all", systemImage: "paperplane")
    //                        .foregroundStyle(.white)
    //                        .padding(6)
    //                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.blue.gradient))
    //                }
    //            }
    //            .padding(.horizontal)
    //        }
    //    }
}


#Preview {
    @Previewable @Environment(\.modelContext) var moc
    SBCalendarPicker(selectionObs: .init(history: BackgroundSerialPersistenceActor(container: moc.container)))
        .preferredColorScheme(.dark)
}
