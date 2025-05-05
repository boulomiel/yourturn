//
//  YTCalendarCell.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SwiftData
import Foundation
import SwiftUI

struct YTCalendarCell: View {
    
    enum DateState {
        case idle
        case selected
        case second
    }
        
    private var isEnabled: Bool {
        cellDate >= startMonthDate &&
        cellDate.day >= Date.now.day
    }
    
    @Environment(\.modelContext) private var moc
    @Namespace private var shapeSpace
    @State private var dateState: DateState = .idle
    @State private var hasSavedList: Bool = false
    
    // - Contructor
    let startMonthDate: Date
    let cellDate: Date
    let size: CGFloat
    @Bindable var selectedObs: YTCalendarSelectionObs
    let onDateSelected: (Date) -> Void
    @Query var shift: [Shift]
    
    init(cellDate: Date, startMonthDate: Date, size: CGFloat, selectedObs: YTCalendarSelectionObs, onDateSelected: @escaping (Date) -> Void) {
        self.cellDate = cellDate
        self.startMonthDate = startMonthDate
        self.size = size
        self.selectedObs = selectedObs
        self.onDateSelected = onDateSelected
        let shiftDate = cellDate
        let predicate = #Predicate<Shift>{ shift in
            shift.date == shiftDate
        }
        var descriptor = FetchDescriptor<Shift>(predicate: predicate)
        descriptor.fetchLimit = 1
        self._shift = .init(descriptor, animation: .bouncy)
    }
    
    var body: some View {
        shape
            .overlay {
                Text("\(cellDate.day)")
                    .font(.body)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
            }
            .onTapGesture {
                onDateSelected(cellDate)
            }
            .disabled(!isEnabled)
            .overlay {
                if let dateRange = selectedObs.range,
                   dateRange.contains(cellDate) {
                   Circle()
                        .stroke(lineWidth: 3)
                        .foregroundStyle(Color.red.gradient.opacity(0.8))
                        .shadow(color: Color.red, radius: 4)
                }
            }
            .overlay(alignment: .topTrailing, content: {
                if shift.last?.date == cellDate {
                    Circle()
                        .fill(Color.red.gradient)
                        .frame(width: 10, height: 10)
                        .padding(4)
                }
            })
            .onChange(of: selectedObs.firstDate?.date) { oldValue, newValue in
                if newValue == cellDate {
                    dateState = .selected
                } else {
                    dateState = .idle
                }
            }
            .onAppear {
              //  fetchDateList()
            }
    }
    
    @ViewBuilder
    var shape: some View {
        RoundedRectangle(cornerRadius: dateState == .selected ? size/2 : 4)
            .fill(isEnabled ? Color.blue.gradient.opacity(1.0) : Color.gray.gradient.opacity(0.6))
            .frame(width:size, height: size)
            .matchedGeometryEffect(id: "selection", in: shapeSpace)
            .onChange(of: selectedObs.range) { oldValue, newValue in
                if let dateRange = newValue,
                   dateRange.contains(cellDate) {
                    dateState = .selected
                } else {
                    dateState = .idle
                }
            }
            .animation(.bouncy, value: dateState)
    }
    
    func fetchDateList() {
        let shiftDate = cellDate
        do {
            let predicate = #Predicate<Shift>{ shift in
                shift.date == shiftDate
            }
            var descriptor = FetchDescriptor<Shift>(predicate: predicate)
            descriptor.fetchLimit = 1
            
            let result = try moc.fetch(descriptor)
            if let dateFound = result.first {
                hasSavedList = true
            }
        } catch {
            print(error)
        }
    }
}
