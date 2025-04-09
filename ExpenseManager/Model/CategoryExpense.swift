//
//  CategoryExpense.swift
//  ExpenseManager
//
//  Created by User on 28.03.2025.
//

import Foundation

struct CategoryExpense: Identifiable {
    
    let id = UUID()
    let category: Category
    let amount: Double
    var title: String {
        return category.title
    }
}
