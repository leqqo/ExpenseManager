//
//  AddExpenseView.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import SwiftUI

struct AddExpenseView: View {
    
    @ObservedObject private var viewModel: CategoryViewModel = CategoryViewModel.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var amount = ""
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(searchText: $viewModel.searchText)
                    Form {
                        TextField("Сумма", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding(8)
                        CategoryGridView(selectedCategory: $selectedCategory)
                            .padding(.top, 12)
                    }
                    .opacity(viewModel.filteredCategories.isEmpty ? 0 : 1)
                    .onChange(of: amount) { _, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        
                        // Проверяем количество точек (должна быть не более одной)
                        let dotCount = filtered.filter { $0 == "." }.count
                        if dotCount > 1 {
                            amount.removeLast()
                        }
                        
                        // Ограничение на два знака после точки
                        if let dotIndex = filtered.firstIndex(of: ".") {
                            let afterDot = filtered[dotIndex...].dropFirst() // Символы после точки
                            if afterDot.count > 2 {
                                amount.removeLast()
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Отмена") {
                                viewModel.searchText = ""
                                presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundStyle(.red)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            Button("Добавить") {
                                if let category = selectedCategory {
                                    let transaction = Transaction(amount: -Int(amount)!, category: category)
                                    MainScreenViewModel.shared.transactions.append(transaction)
                                }
                                viewModel.searchText = ""
                                presentationMode.wrappedValue.dismiss()
                            }
                            .disabled(amount.isEmpty || selectedCategory == nil)
                        }
                    }
                    .toolbarBackground(.white, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
                if viewModel.filteredCategories.isEmpty {
                    Text("Ничего не найдено")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
    }
    
    func categoryChecker(_ amount: String, category: Category) -> Int {
        switch category.title {
        case "Зарплата": return +Int(amount)!
        default:
            return -Int(amount)!
        }
    }
}

#Preview {
    AddExpenseView()
}
