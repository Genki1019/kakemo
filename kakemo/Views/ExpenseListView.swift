//
//  ExpenseListView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import SwiftUI
import RealmSwift

struct ExpenseListView: View {
    @ObservedResults(Expense.self) var expenses
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses) { expense in
                    VStack(alignment: .leading) {
                        Text(expense.category?.name ?? "")
                            .font(.headline)
                        Text(expense.paymentMethod?.name ?? "")
                            .font(.headline)
                        Text("¥\(Int(expense.amount))")
                            .font(.subheadline)
                        Text(expense.date, style: .date)
                            .font(.caption)
                    }
                }
                .onDelete(perform: $expenses.remove)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationLink("カテゴリ", destination: CategoryListView())
                        NavigationLink("支払い方法", destination: PaymentMethodListView())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddExpenseView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ExpenseListView()
}
