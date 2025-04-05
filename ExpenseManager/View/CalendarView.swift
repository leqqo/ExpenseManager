//
//  Calendar.swift
//  ExpenseManager
//
//  Created by User on 02.04.2025.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel = CalendarViewModel.shared
    
    let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: { viewModel.changeYear(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Text(viewModel.currentYear, format: .dateTime.year())
                        .font(.headline)
                    
                    Button(action: { viewModel.changeYear(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                let weekDays = calendar.shortWeekdaySymbols
                
                HStack {
                    ForEach(weekDays, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                let days = viewModel.getDaysInYear()
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 46) {
                            let groupedByMonth = Dictionary(grouping: days, by: { $0.0 })
                            
                            let monthOrder = calendar.monthSymbols
                            
                            ForEach(monthOrder.indices, id: \.self) { index in
                                let month = monthOrder[index]
                                if let dates = groupedByMonth[month] {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Spacer().frame(width: 12)
                                            Text(month)
                                                .font(.headline)
                                                .foregroundStyle(.blue)
                                                .bold()
                                                .padding(.bottom, 12)
                                                .id(index)
                                        }
                                        
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                                            ForEach(dates, id: \.1) { (_, date) in
                                                Button(action: { viewModel.selectDate(date) }) {
                                                    Text("\(calendar.component(.day, from: date))")
                                                        .frame(width: 40, height: 40)
                                                        .background(viewModel.getColor(for: "background", date: date))
                                                        .clipShape(Circle())
                                                        .foregroundColor(viewModel.getColor(for: "foreground", date: date))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.scrollToCurrentMonth(scrollViewProxy: proxy)
                        }
                    }
                    .onChange(of: viewModel.currentYear) { _, _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.scrollToCurrentMonth(scrollViewProxy: proxy)
                        }
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        viewModel.setCurrentMonthRange()
                        viewModel.isCalendarShow = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        viewModel.isCalendarShow = false
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
