//
//  CategoryPickerView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/06.
//

import SwiftUI
import RealmSwift

struct CategoryPickerView: View {
    @ObservedResults(Category.self, sortDescriptor: SortDescriptor(keyPath: "order", ascending: true)) var categories
    @Binding var selectedId: ObjectId?
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(categories) { cat in
                    Button {
                        selectedId = cat.id
                    } label: {
                        VStack {
                            Image(systemName: cat.iconName)
                                .font(.title2)
                                .frame(width:44, height:32)
                                .foregroundColor(Color(hex: cat.colorHex))
                            
                            Text(cat.name)
                                .font(.caption)
                                .foregroundColor(colorScheme == .dark ? .white : .secondary)
                        }
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    selectedId == cat.id
                                    ? (colorScheme == .dark ? .white : .gray)
                                    : Color.gray.opacity(colorScheme == .dark ? 0.6 : 0.3),
                                    lineWidth: 1
                                )
                        )
                    }
                }
                
                // 編集/追加ボタン
                NavigationLink(destination: CategoryListView()) {
                    VStack {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .frame(width:44, height:32)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .secondary)
                        Text("編集")
                            .font(.caption)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .secondary)
                    }
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(colorScheme == .dark ? 0.6 : 0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding(6)
        .frame(maxHeight: 200)
        .onAppear {
            if selectedId == nil, let first = categories.first {
                selectedId = first.id
            }
        }
    }
}
