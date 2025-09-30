//
//  ExpenseDaySectionView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/09.
//

import SwiftUI
import RealmSwift

struct ExpenseDaySectionView: View {
    let date: Date
    let items: [Expense]
    var onDelete: (IndexSet) -> Void
    var onTapEdit: (Expense) -> Void
    
    var body: some View {
        Section(header: Text(date.dayTitleString)) {
            ForEach(items, id: \.id) { expense in
                Button {
                    onTapEdit(expense)
                } label: {
                    expenseRow(expense)
                }
            }
            .onDelete(perform: onDelete)
        }
    }
    
    @ViewBuilder
    private func expenseRow(_ expense: Expense) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                categoryView(expense)
                paymentMethodView(expense)
                if let memo = expense.memo, !memo.isEmpty {
                    Text("(\(memo))")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            
            Spacer()
            Text("¥\(expense.amount)")
                .font(.title2)
        }
        .font(.headline)
    }
    
    @ViewBuilder
    private func categoryView(_ expense: Expense) -> some View {
        if let category = expense.category {
            HStack(spacing: 4) {
                Image(systemName: category.iconName)
                    .foregroundColor(Color(hex: category.colorHex))
                Text(category.name)
            }
        } else {
            HStack(spacing: 4) {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                Text("カテゴリなし")
            }
        }
    }
    
    @ViewBuilder
    private func paymentMethodView(_ expense: Expense) -> some View {
        if let payment = expense.paymentMethod {
            HStack(spacing: 4) {
                Image(systemName: payment.iconName)
                    .foregroundColor(Color(hex: payment.colorHex))
                Text(payment.name)
            }
        } else {
            HStack(spacing: 4) {
                Image(systemName: "circle.fill")
                    .foregroundColor(.gray)
                Text("支払い方法なし")
            }
        }
    }
}
