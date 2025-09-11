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
                HeaderView(selectedMonth: selectedMonth, monthlyTotal: monthlyTotal, onChangeMonth: changeMonth)
                
                CalendarView(selectedMonth: selectedMonth, totals: dailyTotals(for: selectedMonth))
            
                HStack {
                    Text("合計支出: ")
                        .font(.headline)
                    Text("¥\(monthlyTotal)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                List {
                    ForEach(groupExpensesByDay(expenses: expenses), id: \.date) { section in
                        ExpenseDaySectionView(date: section.date, items: section.items)
                    }
                    .onDelete(perform: $expenses.remove)
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

    private func dailyTotals(for date: Date) -> [Date: Int] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
            return [:]
        }
        let monthlyExpenses = expenses.where {
            $0.date >= monthStart && $0.date <= monthEnd
        }
        
        let grouped = Dictionary(grouping: monthlyExpenses) { calendar.startOfDay(for: $0.date) }
        return grouped.mapValues { $0.reduce(0) { $0 + $1.amount } }
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
