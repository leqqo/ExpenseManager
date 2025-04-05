//
//  SearchBar.swift
//  ExpenseManager
//
//  Created by User on 06.04.2025.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        TextField("Поиск по категориям", text: $searchText)
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
}

#Preview {
    SearchBar(searchText: .constant("Продукты"))
}
