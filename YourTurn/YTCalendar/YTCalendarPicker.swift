//
//  YTCalendarPicker.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftUI

struct YTCalendarPicker: View {
    
    @State var obs: YTCalendarPickerObs = .init()
    @State var selectionObs: YTCalendarSelectionObs = .init()
    
    
    @Environment(\.modelContext) private var moc
    @State private var sheetDate: SheetDate?
    @Namespace private var pickerSpace

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                GeometryReader { geo in
                    let size = geo.size
                    if !obs.weeks.isEmpty {
                        calendarGridView(size: size)
                    }
                }
            }
            .navigationTitle(obs.monthName)
            .padding(.top, 40)
            .overlay(alignment: .bottom) {
                YTPopupView(state: selectionObs.calendarPopup)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let date = selectionObs.firstDate?.date {
                            self.sheetDate = .init(date: date)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(selectionObs.firstDate != nil ? Color.blue.gradient.opacity(1.0) : Color.gray.gradient.opacity(0.6))
                            .frame(width: 30, height: 30, alignment: .center)
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                            }
                    }
                }
            }
            .sheet(item: $sheetDate) {
                selectionObs.firstDate = nil
            } content: { sheet in
                YTHourShift(obs: .init(modelContainer: moc.container, date: sheet.date))
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
                        YTCalendarCell(cellDate: date, startMonthDate: obs.startMonthDate, size: cellSize, selectedObs: selectionObs) { date in
                            selectionObs.handleSelectedDate(at: index, with: date)
                        }
                    }
                }
            }

        }
    }
}

struct SheetDate: Identifiable {
    
    var id: TimeInterval {
        date.timeIntervalSince1970
    }
    let date: Date
}

#Preview {
    YTCalendarPicker()
        .preferredColorScheme(.dark)
}
