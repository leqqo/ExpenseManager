//
//  EditTransactionView.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import SwiftUI

struct EditTransactionView: View {
    
    @ObservedObject private var viewModel: CategoryViewModel = CategoryViewModel.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    let transaction: Transaction?
    
    @State private var amount: String
    @State private var category: Category?
    
    init(transaction: Transaction?) {
        self.transaction = transaction
        _amount = State(initialValue: String(transaction?.amount ?? 0))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(searchText: $viewModel.searchText)
                    Form {
                        TextField("Введите сумму", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding(8)
                            .onChange(of: amount) { _, newValue in
                                // Очистить нечисловые символы, чтобы пользователь мог вводить только цифры
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    self.amount = filtered
                                }
                            }
                        
                        CategoryGridView(selectedCategory: $category)
                            .padding(.top, 12)
                    }
                    .opacity(viewModel.filteredCategories.isEmpty ? 0 : 1)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Отмена") {
                                viewModel.searchText = ""
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Сохранить") {
                                guard let validAmount = Int(amount), let selectedCategory = category else { return }
                                
                                if let index = MainScreenViewModel.shared.transactions.firstIndex(where: { $0.id == transaction?.id }) {
                                    
                                    // Обновляем транзакцию
                                    MainScreenViewModel.shared.transactions[index].amount = validAmount
                                    MainScreenViewModel.shared.transactions[index].category.title = selectedCategory.title
                                    MainScreenViewModel.shared.transactions[index].category.icon = selectedCategory.icon
                                    
                                }
                                
                                viewModel.searchText = ""
                                presentationMode.wrappedValue.dismiss()
                            }
                            .disabled(amount.isEmpty || category == nil)
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
}

#Preview {
    EditTransactionView(transaction: Transaction(amount: 150, category: Category(title: "Продукты", icon: "cart")))
}
