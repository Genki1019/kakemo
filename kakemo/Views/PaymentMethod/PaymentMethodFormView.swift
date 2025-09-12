//
//  PaymentMethodFormView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/13.
//

import SwiftUI
import RealmSwift

struct PaymentMethodFormView: View {
    @Environment(\.dismiss) var dismiss
    
    var editingPaymentMethod: PaymentMethod?
    
    @State private var name: String
    @State private var selectedIcon: String?
    @State private var selectedColor: String?
    @State private var showColorPicker = false
    
    @State private var isCompleted = false
    
    init(editingPaymentMethod: PaymentMethod? = nil) {
        self.editingPaymentMethod = editingPaymentMethod
        _name = State(initialValue: editingPaymentMethod?.name ?? "")
        _selectedIcon = State(initialValue: editingPaymentMethod?.iconName)
        _selectedColor = State(initialValue: editingPaymentMethod?.colorHex)
    }
    
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
                    ScrollView(.vertical, showsIndicators: true) {
                        IconSelectionView(selectedIcon: $selectedIcon)
                    }
                    .frame(maxHeight: 240)
                }
                
                // カラー
                VStack(alignment: .leading) {
                    Text("カラー").font(.headline)
                    ScrollView(.vertical, showsIndicators: true) {
                        ColorSelectionView(selectedColor: $selectedColor, showColorPicker: $showColorPicker)
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
                Button(action: savePaymentMethod) {
                    Text(editingPaymentMethod == nil ? "保存" : "更新")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationBarTitle(editingPaymentMethod == nil ? "支払い方法追加" : "支払い方法編集")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .overlay(
            Group {
                if isCompleted {
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding(.bottom)
                        Text(editingPaymentMethod == nil ? "登録が完了しました" : "上書きしました")
                            .font(.headline)
                    }
                    .padding(50)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
                    .shadow(radius: 8)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
    
    private func savePaymentMethod() {
        do {
            let realm = try Realm()
            try realm.write {
                if let editingPaymentMethod, let thawed = editingPaymentMethod.thaw() {
                    // 編集
                    thawed.name = name
                    thawed.iconName = selectedIcon ?? "star"
                    thawed.colorHex = selectedColor ?? "#000000"
                } else {
                    // 新規
                    let paymentMethod = PaymentMethod()
                    paymentMethod.name = name
                    paymentMethod.iconName = selectedIcon ?? "star"
                    paymentMethod.colorHex = selectedColor ?? "#000000"
                    paymentMethod.order = realm.objects(PaymentMethod.self).count + 1
                    realm.add(paymentMethod)
                }
            }
            
            withAnimation { isCompleted = true }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation { isCompleted = false }
                dismiss()
            }
        } catch {
            print("Realm error:", error.localizedDescription)
        }
    }
}

