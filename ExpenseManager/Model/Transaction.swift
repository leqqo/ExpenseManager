//
//  Transaction.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import Foundation

struct Transaction: Identifiable, Codable, Equatable {
    
    let id: UUID
    let date: Date
    var amount: Int
    var category: Category
    
    var icon: String {
        return category.icon
    }
    
    init(id: UUID = UUID(), date: Date = Date(), amount: Int, category: Category) {
        self.id = id
        self.date = date
        self.amount = amount
        self.category = category
    }
}
