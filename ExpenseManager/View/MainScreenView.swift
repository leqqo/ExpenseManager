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
    
    var body: some View {
        NavigationView {
                    VStack {
                        ChartPieView()
                            .padding(.top, 36)
                        List {
                            ForEach(viewModel.groupedTransactions, id: \.key) { key, dayTransactions in
                                Section(header:
                                            HStack {
                                    Text(key)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                        .padding(.vertical, 6)
                                        .padding(.leading, 24)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(uiColor: .systemBackground))
                                }
                                    .listRowInsets(EdgeInsets())
                                ) {
                                    
                                    ForEach(dayTransactions) { transaction in
                                        HStack {
                                            Label(title: {
                                                Text(transaction.category.title)
                                                    .padding(.leading, -6)
                                            }, icon: {
                                                Image(systemName: transaction.icon)
                                            })
                                                .font(.body)
                                            Spacer()
                                            Text("\(formatAmount(transaction.amount))")
                                                .fontWeight(.medium)
                                        }
                                        .listRowSeparator(.hidden)
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
                        .listStyle(.plain)
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
    
    func formatAmount(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " " // Разделитель тысяч — пробел
        formatter.maximumFractionDigits = 0 // Без копеек

        let formattedAmount = formatter.string(from: NSNumber(value: abs(amount))) ?? "\(amount)"
        return "-\(formattedAmount) ₴"
    }

}

#Preview {
    MainScreenView()
}
