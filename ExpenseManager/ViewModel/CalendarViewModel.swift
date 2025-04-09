//
//  CalendarViewModel.swift
//  ExpenseManager
//
//  Created by User on 02.04.2025.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    
    static let shared = CalendarViewModel()
    init() {}
    
    @Published var selectedStartDate: Date? = nil {
        didSet {
            MainScreenViewModel.shared.updateExpensesByCategory()
        }
    }
    @Published var selectedEndDate: Date? = nil {
        didSet {
            MainScreenViewModel.shared.updateExpensesByCategory()
        }
    }
    @Published var currentYear: Date = Date()
    @Published var isCalendarShow: Bool = false
    @Published var currentMonthIndex: Int = 0
    
    let calendar = Calendar.current
    let currentDate: Date = Date()
    
    func scrollToCurrentMonth(scrollViewProxy: ScrollViewProxy) {
        let currentYearInt = calendar.component(.year, from: currentDate)
        let selectedYearInt = calendar.component(.year, from: currentYear)
        
        if currentYearInt == selectedYearInt {
            let currentMonthIndex = calendar.component(.month, from: currentDate) - 1
            scrollViewProxy.scrollTo(currentMonthIndex, anchor: .center)
        } else {
            scrollViewProxy.scrollTo(0, anchor: .center)
        }
    }
    
    func setCurrentMonthRange() {
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, second: -1), to: startOfMonth)
        else { return }

        selectedStartDate = startOfMonth
        selectedEndDate = endOfMonth
    }

    func getDaysInYear() -> [(String, Date)] {
        let firstOfYear = calendar.date(from: calendar.dateComponents([.year], from: currentYear))!
        
        guard let range = calendar.range(of: .day, in: .year, for: firstOfYear) else { return [] }
        
        
        return range.compactMap { day -> (String, Date)? in
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfYear) {
                let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
                return (monthName, date)
            }
            return nil
        }
    }

    func getColor(for UI: String, date: Date) -> Color {
        if UI == "foreground" {
            if let start = selectedStartDate, let end = selectedEndDate, date >= start && date <= end {
                return .white
            }
            if selectedStartDate == date || selectedEndDate == date {
                return .white
            }
            return .black
        }
        
        if UI == "background" {
            if let start = selectedStartDate, let end = selectedEndDate, date >= start && date <= end {
                return .blue
            }
            if selectedStartDate == date || selectedEndDate == date {
                return .blue
            }
            return .clear
        }
        
        fatalError("Unexpected UI type: \(UI)")
    }

    func changeYear(by offset: Int) {
        if let newYear = calendar.date(byAdding: .year, value: offset, to: currentYear) {
            currentYear = newYear
        }
    }

    func selectDate(_ date: Date) {
        if selectedStartDate == nil {
            selectedStartDate = date
        } else if selectedEndDate == nil && selectedStartDate != date {
            selectedEndDate = date
            if let start = selectedStartDate, let end = selectedEndDate, start > end {
                swap(&selectedStartDate, &selectedEndDate)
            }
        } else {
            if selectedStartDate == date || selectedEndDate == date {
                selectedStartDate = date
                selectedEndDate = nil
            } else {
                selectedStartDate = date
                selectedEndDate = nil
            }
        }
    }
}

#Preview {
    ChartPieView()
}

