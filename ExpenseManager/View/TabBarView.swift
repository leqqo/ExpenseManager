//
//  TabBarView.swift
//  ExpenseManager
//
//  Created by User on 30.03.2025.
//

import SwiftUI

struct TabBarView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        TabView {
            MainScreenView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }

            CategoryView()
                .tabItem {
                    Label("Категории", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    TabBarView()
}
