//
//  ExenseFormView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import SwiftUI
import RealmSwift

struct ExpenseFormView: View {
    @State var date: Date = Date()
    var onTapDate: ((_ current: Date, _ onSelected: @escaping (Date) -> Void) -> Void)? = nil
    
    var showCloseButton: Bool
    @Binding var isPresented: Bool
    var editingExpense: Expense?
    
    @ObservedResults(Category.self) var categories
    @ObservedResults(PaymentMethod.self) var paymentMethods
    
    @State private var amount: Int
    @State private var amountText: String
    @State private var memo: String
    @State private var selectedCategoryId: ObjectId?
    @State private var selectedPaymentMethodId: ObjectId?
    
    @FocusState private var isFocused: Bool
    @State private var isCompleted = false
    
    init(editingExpense: Expense? = nil,
         initialDate: Date = Date(),
         showCloseButton: Bool = false,
         isPresented: Binding<Bool>? = nil,
         onTapDate: ((_ current: Date, _ onSelected: @escaping (Date) -> Void) -> Void)? = nil) {
        
        self.editingExpense = editingExpense
        self.showCloseButton = showCloseButton
        _date = State(initialValue: editingExpense?.date ?? initialDate)
        self.onTapDate = onTapDate
        
        _amount = State(initialValue: editingExpense?.amount ?? 0)
        _amountText = State(initialValue: "\(editingExpense?.amount ?? 0)")
        _memo = State(initialValue: editingExpense?.memo ?? "")
        _selectedCategoryId = State(initialValue: editingExpense?.category?.id)
        _selectedPaymentMethodId = State(initialValue: editingExpense?.paymentMethod?.id)
        
        _isPresented = isPresented ?? .constant(true)
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
                            Button {
                                onTapDate?(date) { newDate in
                                    self.date = newDate
                                }
                            } label: {
                                Text(date.dayTitleString)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
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
                        
                        Button(action: saveExpense) {
                            Text(editingExpense == nil ? "登録" : "上書き")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
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
                        Text(editingExpense == nil ? "登録が完了しました" : "上書きしました")
                            .font(.headline)
                    }
                    .padding(50)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
                    .shadow(radius: 8)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationBarItems(leading: closeButton)
        }
    }
    
    @ViewBuilder
    private var closeButton: some View {
        if showCloseButton {
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "chevron.left")
            }
        }
    }
    
    private func saveExpense() {
        do {
            let realm = try Realm()
            try realm.write {
                if let editingExpense, let thawed = editingExpense.thaw() {
                    // 編集モード
                    thawed.date = date
                    thawed.amount = amount
                    if let cid = selectedCategoryId {
                        thawed.category = realm.object(ofType: Category.self, forPrimaryKey: cid)
                    }
                    if let pid = selectedPaymentMethodId {
                        thawed.paymentMethod = realm.object(ofType: PaymentMethod.self, forPrimaryKey: pid)
                    }
                    thawed.memo = memo
                } else {
                    // 新規作成モード
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
            }
            
            withAnimation {
                isCompleted = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    isCompleted = false
                }
                if editingExpense == nil {
                    // 新規登録のときだけリセット
                    date = Date()
                    amount = 0
                    amountText = "0"
                    memo = ""
                    selectedCategoryId = nil
                    selectedPaymentMethodId = nil
                }
                isPresented = false
            }
        } catch {
            print("Realm error: \(error.localizedDescription)")
        }
    }
}
