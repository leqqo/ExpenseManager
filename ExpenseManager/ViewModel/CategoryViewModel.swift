//
//  CategoryViewModel.swift
//  ExpenseManager
//
//  Created by User on 28.03.2025.
//

import Foundation
import SwiftUI

class CategoryViewModel: ObservableObject {
    
    static let shared = CategoryViewModel()
    init() { loadCategories() }
    
    @Published var searchText: String = ""
    let iconSections: [IconSection] = [
        IconSection(title: "Финансы и работа", icons: [
            "dollarsign.circle.fill",
            "creditcard.fill",
            "doc.plaintext.fill",
            "briefcase.fill",
            "chart.bar.fill",
            "banknote.fill",
            "building.2.fill",
            "calendar.badge.clock"
        ]),
        
        IconSection(title: "Покупки и повседневные расходы", icons: [
            "cart.fill",
            "cup.and.saucer.fill",
            "tshirt.fill",
            "wrench.and.screwdriver.fill",
            "gift.fill",
            "basket.fill",
            "bag.fill",
            "shippingbox.fill"
        ]),
        
        IconSection(title: "Дом и жильё", icons: [
            "house.fill",
            "wifi",
            "pawprint.fill",
            "lightbulb.fill",
            "bed.double.fill",
            "sofa.fill",
            "fanblades.fill",
            "hammer.fill"
        ]),
        
        IconSection(title: "Транспорт", icons: [
            "car.fill",
            "bicycle",
            "bus.fill",
            "fuelpump.fill",
            "scooter",
            "car.2.fill",
            "steeringwheel",
            "tram.fill"
        ]),
        
        IconSection(title: "Здоровье и уход", icons: [
            "cross.case.fill",
            "pills.fill",
            "figure.run.circle.fill",
            "scissors",
            "heart.fill",
            "bandage.fill",
            "stethoscope",
            "drop.fill"
        ]),
        
        IconSection(title: "Образование и развитие", icons: [
            "book.fill",
            "graduationcap.fill",
            "pencil.and.outline",
            "brain.head.profile",
            "books.vertical.fill",
            "globe",
            "lightbulb",
            "person.crop.rectangle"
        ]),
        
        IconSection(title: "Досуг и развлечения", icons: [
            "gamecontroller.fill",
            "airplane",
            "paintpalette.fill",
            "film.fill",
            "music.note.house.fill",
            "ticket.fill",
            "theatermasks.fill",
            "camera.fill"
        ]),
        
        IconSection(title: "Дети", icons: [
            "figure.2.and.child.holdinghands",
            "puzzlepiece.fill",
            "book.circle.fill"
        ]),
        
        IconSection(title: "Прочее", icons: [
            "questionmark.circle.fill",
            "ellipsis.circle.fill",
            "sparkles",
            "circle.grid.3x3.fill",
            "gear"
        ])
    ]

    
    @Published var categories: [Category] = [
        
        // Основные расходы
        Category(title: "Продукты", icon: "cart.fill"),
        Category(title: "Кафе и рестораны", icon: "cup.and.saucer.fill"),
        Category(title: "Одежда и обувь", icon: "tshirt.fill"),
        Category(title: "Транспорт", icon: "car.fill"),
        Category(title: "Жильё и коммуналка", icon: "house.fill"),
        
        // Быт
        Category(title: "Бытовые товары", icon: "wrench.and.screwdriver.fill"),
        Category(title: "Домашние животные", icon: "pawprint.fill"),
        Category(title: "Подарки", icon: "gift.fill"),
        Category(title: "Связь и интернет", icon: "wifi"),
        
        // Здоровье и красота
        Category(title: "Здоровье", icon: "cross.case.fill"),
        Category(title: "Аптека", icon: "pills.fill"),
        Category(title: "Спорт и фитнес", icon: "figure.run.circle.fill"),
        Category(title: "Уход за собой", icon: "scissors"),
        
        // Образование и работа
        Category(title: "Образование", icon: "book.fill"),
        Category(title: "Работа и бизнес", icon: "briefcase.fill"),
        
        // Развлечения и досуг
        Category(title: "Развлечения", icon: "gamecontroller.fill"),
        Category(title: "Путешествия", icon: "airplane"),
        Category(title: "Хобби", icon: "paintpalette.fill"),
        
        // Дети
        Category(title: "Дети", icon: "figure.2.and.child.holdinghands"),
        
        // Финансовые обязательства
        Category(title: "Кредиты и долги", icon: "creditcard.fill"),
        Category(title: "Налоги и сборы", icon: "doc.plaintext.fill"),
        
        // Прочее
        Category(title: "Прочее", icon: "questionmark.circle.fill")
    ] {
        didSet {
            saveCategories()
        }
    }
    
    private func loadCategories() {
            if let data = UserDefaults.standard.data(forKey: "categories") {
                do {
                    categories = try JSONDecoder().decode([Category].self, from: data)
                } catch {
                    print("Не удалось загрузить категории: \(error)")
                }
            }
        }
        
        private func saveCategories() {
            do {
                let data = try JSONEncoder().encode(categories)
                UserDefaults.standard.set(data, forKey: "categories")
            } catch {
                print("Не удалось сохранить категории: \(error)")
            }
        }
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}

