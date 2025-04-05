//
//  ChartPieViewModel.swift
//  ExpenseManager
//
//  Created by User on 01.04.2025.
//

import Foundation
import SwiftUI

class ChartPieViewModel: ObservableObject {
    
    static let shared = ChartPieViewModel()
    init() { loadColors()
        //UserDefaults.standard.removeObject(forKey: "categoryColors")
    }
    
    var categoryColors: [String: String] = [
        // Основные расходы
        "Продукты": Color.green.toHex(),
        "Кафе и рестораны": Color.brown.toHex(),
        "Одежда и обувь": Color.purple.toHex(),
        "Транспорт": Color.blue.toHex(),
        "Жильё и коммуналка": Color.red.toHex(),
        
        // Быт
        "Бытовые товары": Color.orange.toHex(),
        "Домашние животные": Color.pink.toHex(),
        "Подарки": Color.indigo.toHex(),
        "Связь и интернет": Color.teal.toHex(),
        
        // Здоровье и красота
        "Здоровье": Color.cyan.toHex(),
        "Аптека": Color(red: 0.2, green: 0.8, blue: 0.2).toHex(), // зелёный оттенок
        "Спорт и фитнес": Color(red: 1.0, green: 0.9, blue: 0.2).toHex(), // жёлтый оттенок
        "Уход за собой": Color(red: 0.6, green: 0.6, blue: 0.6).toHex(), // серый оттенок
        
        // Образование и работа
        "Образование": Color(red: 0.7, green: 0.1, blue: 0.9).toHex(), // фиолетовый оттенок
        "Работа и бизнес": Color(red: 0.5, green: 0.5, blue: 0.5).toHex(), // серый оттенок
        
        // Развлечения и досуг
        "Развлечения": Color(red: 0.8, green: 1.0, blue: 0.2).toHex(), // лайм
        "Путешествия": Color(red: 0.5, green: 0.2, blue: 0.8).toHex(), // фиолетовый оттенок
        "Хобби": Color(red: 1.0, green: 0.6, blue: 0.1).toHex(), // оранжевый оттенок
        
        // Дети
        "Дети": Color(red: 0.4, green: 0.8, blue: 0.4).toHex(), // зелёный оттенок
        
        // Финансовые обязательства
        "Кредиты и долги": Color(red: 0.8, green: 0.2, blue: 0.2).toHex(), // красный оттенок
        "Налоги и сборы": Color(red: 0.1, green: 0.7, blue: 0.7).toHex(), // голубой оттенок
        
        // Прочее
        "Прочее": Color.gray.toHex()
    ] {
        didSet {
            saveColors()
        }
    }


    
    func getColor(for category: String) -> Color {
           if let hex = categoryColors[category] {
               return Color.fromHex(hex)
           }
           return .gray
       }
    
    func setColor(for category: String, color: Color) {
           categoryColors[category] = color.toHex()
       }
    
    func generateRandomColor() -> Color {
        var randomColor: Color
        let existingColorValues = Set(categoryColors.values)
        
        repeat {
            randomColor = Color(
                red: Double.random(in: 0...1),
                green: Double.random(in: 0...1),
                blue: Double.random(in: 0...1)
            )
        } while existingColorValues.contains(randomColor.toHex())

        return randomColor
    }
    
    private func loadColors() {
            if let data = UserDefaults.standard.data(forKey: "categoryColors") {
                do {
                    categoryColors = try JSONDecoder().decode([String:String].self, from: data)
                } catch {
                    print("Не удалось загрузить категории: \(error)")
                }
            }
        }
        
        private func saveColors() {
            do {
                let data = try JSONEncoder().encode(categoryColors)
                UserDefaults.standard.set(data, forKey: "categoryColors")
            } catch {
                print("Не удалось сохранить категории: \(error)")
            }
        }
}
