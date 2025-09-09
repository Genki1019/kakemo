//
//  AddExenseView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import SwiftUI
import RealmSwift

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(Category.self) var categories
    @ObservedResults(PaymentMethod.self) var paymentMethods
    
    @State private var date = Date()
    @State private var amount = 0
    @State private var amountText: String = "0"
    @FocusState private var isFocused: Bool
    @State private var memo = ""
    
    @State private var selectedCategoryId: ObjectId?
    @State private var selectedPaymentMethodId: ObjectId?
    
    @State private var isCompleted = false

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E)"
        return formatter.string(from: date)
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // 日付
                        HStack {
                            Button {
                                date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            Spacer()
                            Text(date.dayTitleString)
                                .font(.headline)
                            Spacer()
                            Button {
                                date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // 支出
                        HStack {
                            Text("支出")
                                .padding(.trailing, 16)
                            
                            TextField("", text: Binding(
                                get: { amountText },
                                set: { newValue in
                                    // 入力値から数字だけを抽出
                                    let filtered = newValue.filter { $0.isNumber }
                                    amountText = filtered
                                    
                                    // 数字があれば Int に反映
                                    if let value = Int(filtered) {
                                        amount = value
                                    } else {
                                        amount = 0
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                            .focused($isFocused)
                            .onChange(of: isFocused) {
                                if isFocused {
                                    if amount == 0 {
                                        amountText = ""
                                    }
                                } else {
                                    if amountText.isEmpty {
                                        amount = 0
                                        amountText = "0"
                                    }
                                }
                            }
                            
                            Text("円")
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // カテゴリ
                        VStack(alignment: .leading) {
                            Text("カテゴリ")
                                .padding(.horizontal)
                            CategoryPickerView(selectedId: $selectedCategoryId)
                        }
                        
                        Divider()
                        
                        // 支払い方法
                        VStack(alignment: .leading) {
                            Text("支払い方法")
                                .padding(.horizontal)
                            PaymentMethodPickerView(selectedId: $selectedPaymentMethodId)
                        }
                        
                        Divider()
                        
                        // メモ
                        HStack {
                            Text("メモ")
                                .padding(.trailing, 16)
                            TextField("未入力", text: $memo)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        Button(action: { saveExpense(date) }) {
                            Text("保存")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                
                if isCompleted {
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding(.bottom)
                        Text("登録が完了しました")
                            .font(.headline)
                    }
                    .padding(50)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
                    .shadow(radius: 8)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    
    private func saveExpense(_ saveDate: Date) {
        do {
            let realm = try Realm()
            try realm.write {
                let expense = Expense()
                expense.date = saveDate
                expense.amount = amount
                if let cid = selectedCategoryId {
                    expense.category = realm.object(ofType: Category.self, forPrimaryKey: cid)
                }
                if let pid = selectedPaymentMethodId {
                    expense.paymentMethod = realm.object(ofType: PaymentMethod.self, forPrimaryKey: pid)
                }
                expense.memo = memo
                
                realm.add(expense)
            }
            
            // リセット
            date = Date()
            amount = 0
            amountText = "0"
            memo = ""
            selectedCategoryId = nil
            selectedPaymentMethodId = nil
            
            withAnimation {
                isCompleted = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isCompleted = false
                }
            }
        } catch {
            print("Realm error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddExpenseView()
}
