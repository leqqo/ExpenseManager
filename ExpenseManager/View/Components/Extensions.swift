//
//  Extensions.swift
//  ExpenseManager
//
//  Created by User on 08.04.2025.
//

import Foundation

extension Date {
    func formattedMonthCapitalized() -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"

        let day = dayFormatter.string(from: self)
        let month = monthFormatter.string(from: self).prefix(1).uppercased() + monthFormatter.string(from: self).dropFirst()
        return "\(day) \(month)"
    }
}

extension Int {
    func formatAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " " // Разделитель тысяч — пробел
        formatter.maximumFractionDigits = 0 // Без копеек
        
        let formattedAmount = formatter.string(from: NSNumber(value: self)) ?? "\(0)"
        return "\(formattedAmount) ₴"
    }
}
