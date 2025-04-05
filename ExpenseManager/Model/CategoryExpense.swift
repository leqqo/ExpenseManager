//
//  CategoryExpense.swift
//  ExpenseManager
//
//  Created by User on 28.03.2025.
//

import Foundation

struct CategoryExpense: Identifiable {
    
    let id = UUID()
    let category: String
    let amount: Double
}
