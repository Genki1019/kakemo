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
    @State private var memo = ""
    
    @State private var selectedCategoryId: ObjectId?
    @State private var selectedPaymentMethodId: ObjectId?

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E)"
        return formatter.string(from: date)
    }

    
    var body: some View {
        NavigationView {
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
                        TextField("", value: $amount, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .font(.title)
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
    
    private func saveExpense(_ date: Date) {
        do {
            let realm = try Realm()
            try realm.write {
                let expense = Expense()
                expense.date = date
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
            dismiss()
        } catch {
            print("Realm error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddExpenseView()
}
