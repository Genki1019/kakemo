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
    
    @State private var selectedMonth: Date = Date()
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text(selectedMonth.monthTitleString)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                HStack {
                    Text("合計支出: ")
                        .font(.headline)
                    Text("¥\(monthlyTotal)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                .padding()
            
                List {
                    ForEach(groupExpensesByDay(expenses: expenses), id: \.date) { section in
                        Section(header: Text(section.date.dayTitleString)) {
                            ForEach(section.items) { expense in
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
                            .onDelete(perform: $expenses.remove)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddExpenseView()) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    private func groupExpensesByDay(expenses: Results<Expense>) -> [(date: Date, items: [Expense])] {
        let calendar = Calendar.current
        
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
            return []
        }
        let monthlyExpenses = expenses.where {
            $0.date >= monthStart && $0.date <= monthEnd
        }
        
        let grouped = Dictionary(grouping: monthlyExpenses) { expense in
            calendar.startOfDay(for: expense.date)
        }
        return grouped
            .map { (date: $0.key, items: $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.date > $1.date }
    }
    
    private var monthlyTotal: Int {
        let calendar = Calendar.current
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
            return 0
        }
        
        let monthlyExpenses = expenses.where {
            $0.date >= monthStart && $0.date <= monthEnd
        }
        
        return monthlyExpenses.reduce(0) { $0 + $1.amount }
    }
}

#Preview {
    ExpenseListView()
}
