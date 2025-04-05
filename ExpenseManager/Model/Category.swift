//
//  Category.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable, Equatable, Hashable {
    
    var id = UUID()
    var title: String
    var icon: String

}

extension Color {
    func toHex() -> String {
            let uiColor = UIColor(self)
            guard let components = uiColor.cgColor.components, components.count >= 3 else {
                return "#FFFFFF"
            }

            let r = Int(components[0] * 255)
            let g = Int(components[1] * 255)
            let b = Int(components[2] * 255)

            return String(format: "#%02X%02X%02X", r, g, b)
        }
    
    static func fromHex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized = String(hexSanitized.dropFirst())
        }
        
        if hexSanitized.count == 6, let rgb = Int(hexSanitized, radix: 16) {
            return Color(
                red: Double((rgb >> 16) & 0xFF) / 255.0,
                green: Double((rgb >> 8) & 0xFF) / 255.0,
                blue: Double(rgb & 0xFF) / 255.0
            )
        }
        
        return .white
    }
}
