//
//  CategoryView.swift
//  ExpenseManager
//
//  Created by User on 26.03.2025.
//

import SwiftUI

struct CategoryView: View {
    
    @ObservedObject var viewModel = CategoryViewModel.shared
    
    @State private var isAddNewCategoryShow: Bool = false
    @State private var title = ""
    @State private var selectedIcon = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $viewModel.searchText)
                ZStack {
                    List(viewModel.filteredCategories) { category in
                        HStack(spacing: 16) {
                            Image(systemName: category.icon)
                                .foregroundColor(.blue)
                                .font(.title2)
                                .frame(width: 28, height: 28)
                            Text(category.title)
                                .fontWeight(.light)
                                .foregroundStyle(.primary)
                        }
                        .background(Color(uiColor: .systemBackground))
                        .swipeActions {
                            Button(role: .destructive) {
                                if let index = viewModel.categories.firstIndex(where: { $0.id == category.id }) {
                                    
                                    MainScreenViewModel.shared.transactions.removeAll { $0.category.title == viewModel.categories[index].title }
                                    
                                    viewModel.categories.remove(at: index)
                                }
                                
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                // Действие для кнопки Edit
                            } label: {
                                Text("Править")
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isAddNewCategoryShow = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                            }
                        }
                    }
                    if viewModel.filteredCategories.isEmpty {
                        Text("Ничего не найдено")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: $isAddNewCategoryShow) {
                NavigationView {
                    Form {
                        TextField("Введите название категории", text: $title)
                            .padding([.top, .bottom], 8)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 28) {
                                ForEach(viewModel.iconSections) { section in
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text(section.title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fontWeight(.regular)
                                                .foregroundStyle(.secondary)
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.gray.opacity(0.1))
                                                )

                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 16) {
                                                ForEach(section.icons, id: \.self) { icon in
                                                    Button {
                                                        if selectedIcon == icon {
                                                            selectedIcon = ""
                                                        } else {
                                                            selectedIcon = icon
                                                        }
                                                    } label: {
                                                        Image(systemName: icon)
                                                            .font(.title)
                                                            .frame(width: 64, height: 64)
                                                            .background(selectedIcon == icon ? Color.gray.opacity(0.15) : Color.clear)
                                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                                            .foregroundColor(.blue)
                                                    }
                                                    .buttonStyle(.plain)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        .padding([.top, .bottom], 12)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                isAddNewCategoryShow = false
                                title = ""
                                selectedIcon = ""
                            } label: {
                                Text("Отмена").foregroundStyle(.red)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                let category = Category(title: title, icon: selectedIcon)
                                ChartPieViewModel.shared.setColor(for: category.title, color: ChartPieViewModel.shared.generateRandomColor())
                                viewModel.categories.append(category)
                                title = ""
                                selectedIcon = ""
                                isAddNewCategoryShow = false
                            } label: {
                                Text("Сохранить")
                            }
                            .disabled(title.isEmpty || selectedIcon.isEmpty)
                        }
                    }
                    .toolbarBackground(.white, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
            
            }
        }
    }
}

#Preview {
    CategoryView()
}

