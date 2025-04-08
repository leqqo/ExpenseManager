//
//  CustomCalendarView.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import SwiftUI
import Charts

struct ChartPieView: View {
    
    @ObservedObject var calendarViewModel = CalendarViewModel.shared
    @ObservedObject var mainScreenViewModel = MainScreenViewModel.shared
    @ObservedObject var chartViewModel = ChartPieViewModel.shared
    
    var displayedDateRange: String {

        if let start = calendarViewModel.selectedStartDate, let end = calendarViewModel.selectedEndDate {
            return "\(start.formattedMonthCapitalized()) - \(end.formattedMonthCapitalized())"
        } else if let start = calendarViewModel.selectedStartDate {
            return start.formattedMonthCapitalized()
        } else {
            return calendarViewModel.currentDate.formattedMonthCapitalized()
        }
    }
      
    var body: some View {
        
        if mainScreenViewModel.transactions.isEmpty {
            VStack(spacing: 8) {
                Text("Транзакции отсутствуют!")
                Text("Чтобы добавить транзакцию, нажмите")
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .foregroundStyle(.blue)
                        .font(.title)
                    Text("в правом верхнем углу")
                }
            }
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .padding(.top, 200)

        } else {
            
            VStack {
                Text(displayedDateRange)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        calendarViewModel.isCalendarShow.toggle()
                    }
                    .sheet(isPresented: $calendarViewModel.isCalendarShow) {
                        CalendarView()
                    }
                Text("Расходы по категориям")
                    .font(.subheadline)
                    .padding(.top, 2)
                
                Chart(mainScreenViewModel.cachedExpensesByCategory) { expense in
                    SectorMark(
                        angle: .value("Сумма", expense.amount),
                        innerRadius: .ratio(0.5)
                    )
                    .foregroundStyle(chartViewModel.getColor(for: expense.category))
                }
                .frame(height: 150)
                .padding()
                .chartLegend(.hidden)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), alignment: .leading, spacing: 10) {
                    ForEach(mainScreenViewModel.cachedExpensesByCategory) { expense in
                        HStack {
                            Circle()
                                .fill(chartViewModel.getColor(for: expense.category))
                                .frame(width: 12, height: 12)
                            
                            Text(expense.category)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            
            .onAppear {
                calendarViewModel.setCurrentMonthRange()
            }
        }
    }
}

#Preview {
    ChartPieView()
}


