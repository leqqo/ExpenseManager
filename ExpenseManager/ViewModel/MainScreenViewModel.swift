//
//  MainScreenViewModel.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import SwiftUI
import Foundation

class MainScreenViewModel: ObservableObject {
    
    static let shared = MainScreenViewModel()
    
    init() {
        //UserDefaults.standard.removeObject(forKey: "transactions")
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd.MM.yyyy"
        
        //let category = Category(title: "Продукты", icon: "cart.fill")
        //transactions.append(Transaction(date: dateFormatter.date(from: "28.03.2025")!, amount: 150, category: category))
        loadTransactions()
    }
    
    @Published var transactions = [Transaction]() {
        didSet {
            saveTransactions()
            updateGroupedTransactions()
            updateExpensesByCategory()
        }
    }
    
    @Published var cachedExpensesByCategory: [CategoryExpense] = []
    var groupedTransactions: [(key: String, value: [Transaction])] = []
    
    private func updateGroupedTransactions() {
        
        let now = Date()
        
        let grouped = Dictionary(grouping: transactions) { transaction in
            
            let currentLocale = Locale.current.language.languageCode?.identifier
            let today = currentLocale == "ru" ? "Сегодня" : "Today"
            let yesterday = currentLocale == "ru" ? "Вчера" : "Yesterday"
            
            if let daysDifference = Calendar.current.dateComponents([.day], from: transaction.date, to: now).day {
                if daysDifference == 0 {
                    return today
                } else if daysDifference == 1 {
                    return yesterday
                } else if daysDifference < 1 {
                    return transaction.date.formattedMonthCapitalized()
                }
            }
            return transaction.date.formattedMonthCapitalized()
        }
        
        groupedTransactions = grouped.map { (key, value) in
            return (key: key, value: value)
        }
        .sorted { $0.key > $1.key }
    }
    
    func updateExpensesByCategory(singleDate: Date? = CalendarViewModel.shared.selectedStartDate, startDate: Date? = CalendarViewModel.shared.selectedStartDate, endDate: Date? = CalendarViewModel.shared.selectedEndDate) -> Void {

        var filteredTransactions: [Transaction] = []
        
        let calendar = Calendar.current
        let today = Date()
        
        let defaultStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let defaultEndDate = calendar.date(byAdding: DateComponents(month: 1, second: -1), to: defaultStartDate)!
        
        if let startDate = startDate, let endDate = endDate {
            filteredTransactions = transactions.filter { $0.date >= startDate && $0.date <= endDate }
        } else if let singleDate = singleDate {
            filteredTransactions = transactions.filter { calendar.isDate($0.date, inSameDayAs: singleDate) }
        } else {
            filteredTransactions = transactions.filter { $0.date >= defaultStartDate && $0.date <= defaultEndDate }
        }
        
        let grouped = Dictionary(grouping: filteredTransactions, by: { $0.category.title })
        
        cachedExpensesByCategory = grouped.map { (_, transactions) in
            let totalAmount = transactions.reduce(0) { $0 + Double($1.amount) }
            let category = transactions.first!.category
            return CategoryExpense(category: category, amount: totalAmount)
        }
        .sorted { $0.amount > $1.amount }
    }
    
    private func loadTransactions() {
            if let data = UserDefaults.standard.data(forKey: "transactions") {
                do {
                    transactions = try JSONDecoder().decode([Transaction].self, from: data)
                } catch {
                    print("Не удалось загрузить транзакции: \(error)")
                }
            }
        }
        
        private func saveTransactions() {
            do {
                let data = try JSONEncoder().encode(transactions)
                UserDefaults.standard.set(data, forKey: "transactions")
            } catch {
                print("Не удалось сохранить транзакции: \(error)")
            }
        }
}
