//
//  ContentView.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import SwiftUI
import Foundation

struct MainScreenView: View {
    
    @ObservedObject var viewModel = MainScreenViewModel.shared
    
    @State private var showAddExpense: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var selectedTransaction: Transaction?
    @State private var showEditView: Bool = false
    @State private var selection = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ChartPieView()
                        .padding(.top, 36)
                    
                    Picker("Picker", selection: $selection) {
                        Text("Статистика").tag(0)
                        Text("История").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top)
                    .padding(.horizontal)
                    .opacity(viewModel.transactions.isEmpty ? 0 : 1)
                    
                    if selection == 0 {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.cachedExpensesByCategory) { transaction in
                                HStackView(transactionTitle: transaction.title, categoryIcon: transaction.category.icon, amount: Int(transaction.amount))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.groupedTransactions, id: \.key) { key, dayTransactions in
                                Section(header: Text(key)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 4)
                                    .padding(.top)
                                ) {
                                    ForEach(dayTransactions) { transaction in
                                        HStackView(transactionTitle: transaction.category.title, categoryIcon: transaction.icon, amount: transaction.amount)
                                        .background(Color(uiColor: .systemBackground))
                                        .clipShape(Rectangle())
                                        .onTapGesture {
                                            selectedTransaction = transaction
                                            showActionSheet.toggle()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(
                                title: Text("Выберите действие"),
                                message: Text("Что вы хотите сделать с этой транзакцией?"),
                                buttons: [
                                    .default(Text("Редактировать")) {
                                        editTransaction(transaction: selectedTransaction)
                                    },
                                    .destructive(Text("Удалить")) {
                                        deleteTransaction(transaction: selectedTransaction)
                                    },
                                    .cancel()
                                ]
                            )
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddExpense = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }
                }
                .toolbarBackground((Color(uiColor: .systemBackground)), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .sheet(isPresented: $showEditView) {
                    EditTransactionView(transaction: selectedTransaction)
                }
            }
        }
            .sheet(isPresented: $showAddExpense, content: {
                AddExpenseView()
            })
    }
    
    func editTransaction(transaction: Transaction?) {
        guard transaction != nil else { return }
        showEditView.toggle()
    }
    
    func deleteTransaction(transaction: Transaction?) {
        guard let transaction = transaction else { return }
        if let index = viewModel.transactions.firstIndex(where: { $0.id == transaction.id }) {
            viewModel.transactions.remove(at: index)
        }
    }
}

#Preview {
    MainScreenView()
}

struct HStackView: View {
    
    var transactionTitle: String
    var categoryIcon: String
    var amount: Int
    
    var body: some View {
        HStack {
            Label(title: {
                Text(transactionTitle)
            }, icon: {
                Image(systemName: categoryIcon)
                    .foregroundStyle(.blue)
                    .font(.title2)
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 2)
            })
            Spacer()
            Text("\(amount.formatAmount())")
                .fontWeight(.medium)
        }
    }
    
   
}
