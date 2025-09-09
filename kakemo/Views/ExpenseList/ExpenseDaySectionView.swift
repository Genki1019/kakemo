//
//  ExpenseDaySectionView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/09.
//

import SwiftUI

struct ExpenseDaySectionView: View {
    let date: Date
    let items: [Expense]
    
    var body: some View {
        Section(header: Text(date.dayTitleString)) {
            ForEach(items) { expense in
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            // カテゴリ
                            if let category = expense.category {
                                HStack(spacing: 4) {
                                    Image(systemName: category.iconName)
                                        .foregroundColor(Color(hex: category.colorHex))
                                    Text(category.name)
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "circle")
                                        .foregroundColor(Color.gray)
                                    Text("カテゴリなし")
                                }
                            }
                            
                            // 支払い方法
                            if let payment = expense.paymentMethod {
                                HStack(spacing: 4) {
                                    Image(systemName: payment.iconName)
                                        .foregroundColor(Color(hex: payment.colorHex))
                                    Text(payment.name)
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color.gray)
                                    Text("支払い方法なし")
                                }
                            }
                        }
                        .font(.headline)
                        
                        Spacer()
                        
                        Text("¥\(expense.amount)")
                            .font(.title2)
                    }
                    
                    if let memo = expense.memo, !memo.isEmpty {
                        Text("(\(memo))")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                }
            }
        }
    }
}
