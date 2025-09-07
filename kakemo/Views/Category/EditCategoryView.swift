//
//  EditCategoryView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/06.
//

import SwiftUI
import RealmSwift

struct EditCategoryView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var category: Category
    
    @State private var name: String = ""
    @State private var selectedIcon: String? = nil
    @State private var selectedColor: String? = nil
    @State private var showColorPicker = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // 名前
                VStack(alignment: .leading) {
                    Text("名前").font(.headline)
                    TextField("項目名を入力してください", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // アイコン
                VStack(alignment: .leading) {
                    Text("アイコン").font(.headline)
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(CategoryOptions.icons, id: \.self) { icon in
                                Button {
                                    selectedIcon = icon
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedIcon == icon ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: selectedIcon == icon ? 2 : 1)
                                            .frame(height: 60)
                                        
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 240)
                }
                
                // カラー
                VStack(alignment: .leading) {
                    Text("カラー").font(.headline)
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(ColorOptions.colors, id: \.self) { hex in
                                Button {
                                    selectedColor = hex
                                } label: {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: hex))
                                        .frame(height: 40)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(selectedColor == hex ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                            
                            // 自由色
                            Button {
                                showColorPicker.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [4]))
                                    .frame(height: 40)
                                    .overlay(Image(systemName: "plus"))
                            }
                        }
                    }
                    .frame(maxHeight: 100)
                    
                    if showColorPicker {
                        ColorPicker("自由に選ぶ", selection: Binding(
                            get: { Color(hex: selectedColor ?? "#000000") },
                            set: { newColor in
                                selectedColor = newColor.toHex() ?? selectedColor
                            }
                        ))
                        .padding(.top, 8)
                    }
                }
                
                // 保存ボタン
                Button(action: { saveChanges() }) {
                    Text("保存")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationBarTitle("カテゴリ編集")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .onAppear {
            name = category.name
            selectedIcon = category.iconName
            selectedColor = category.colorHex
        }
    }
    
    private func saveChanges() {
        let realm = try! Realm()
        try! realm.write {
            if let thawedCategory = category.thaw() {
                thawedCategory.name = name
                thawedCategory.iconName = selectedIcon ?? "star"
                thawedCategory.colorHex = selectedColor ?? "#000000"
            }
        }
        dismiss()
    }
}

#Preview {
    let realm = try! Realm()
    let category = realm.objects(Category.self).first ?? Category(value: ["name": "サンプル", "iconName": "star", "colorHex": "#FFD700", "order": 0])
    return NavigationStack {
        EditCategoryView(category: category)
    }
}
