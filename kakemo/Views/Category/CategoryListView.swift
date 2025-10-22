//
//  CategoryListView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import SwiftUI
import RealmSwift

struct CategoryListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedResults(Category.self, sortDescriptor: SortDescriptor(keyPath: "order", ascending: true)) var categories
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: CategoryFormView()) {
                    Label("新規カテゴリを追加", systemImage: "plus.circle")
                }
            }
            
            Section {
                ForEach(categories, id: \.id) { category in
                    categoryRow(category)
                }
                .onDelete(perform: deleteCategory)
                .onMove(perform: moveCategory)
            }
        }
        .navigationTitle("カテゴリ一覧")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    private func categoryRow(_ category: Category) -> some View {
        NavigationLink(destination: CategoryFormView(editingCategory: category)) {
            HStack {
                Image(systemName: category.iconName)
                    .foregroundColor(Color(hex: category.colorHex))
                Text(category.name)
            }
        }
    }
    
    // 削除処理
    private func deleteCategory(at offsets: IndexSet) {
        do {
            let realm = try Realm()
            try realm.write {
                offsets.forEach { index in
                    let cat = categories[index]
                    if cat.isFrozen {
                        if let liveCat = realm.object(ofType: Category.self, forPrimaryKey: cat.id) {
                            realm.delete(liveCat)
                        }
                    } else {
                        realm.delete(cat)
                    }
                }
            }
        } catch {
            print("Realm delete error:", error)
        }
    }
    
    // 並べ替え処理
    private func moveCategory(from source: IndexSet, to destination: Int) {
        let current = Array(categories)
        guard let fromIndex = source.first else { return }
        
        let moveCat = current[fromIndex]
        let realm = try! Realm()
        
        try? realm.write {
            if fromIndex < destination {
                // 下へ移動する場合
                for i in (fromIndex + 1)...(destination - 1) {
                    let cat = realm.object(ofType: Category.self, forPrimaryKey: current[i].id)
                    cat?.order -= 1
                }
                let liveMoveCat = realm.object(ofType: Category.self, forPrimaryKey: moveCat.id)
                liveMoveCat?.order = destination - 1
            } else if destination < fromIndex {
                // 上へ移動する場合
                for i in (destination...(fromIndex - 1)).reversed() {
                    let cat = realm.object(ofType: Category.self, forPrimaryKey: current[i].id)
                    cat?.order += 1
                }
                let liveMoveCat = realm.object(ofType: Category.self, forPrimaryKey: moveCat.id)
                liveMoveCat?.order = destination
            }
        }
    }
}
