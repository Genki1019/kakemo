//
//  ReportView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI
import Charts
import RealmSwift

enum ChartType: String, CaseIterable {
    case category = "カテゴリ"
    case paymentMethod = "支払い方法"
}

struct ReportView: View {
    @State private var selectedMonth: Date = Date()
    var onTapMonth: ((_ current: Date, _ onSelected: @escaping (Date) -> Void) -> Void)
    
    @ObservedResults(Expense.self) var expenses
    
    @State private var selectedChart: ChartType = .category
    private let calendar = Calendar.current
    
    struct PieSlice {
        let name: String
        let value: Double
        let color: Color
        let icon: String
    }
    
    private var montlyExpenses: [Expense] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)
        else { return [] }
        
        return Array(expenses.where {
            $0.date >= monthStart && $0.date <= monthEnd
        })
    }
    
    private var currentSlices: [PieSlice] {
        switch selectedChart {
        case .category:
            return aggregateCategoryRealm(montlyExpenses)
        case .paymentMethod:
            return aggregatePaymentMethodRealm(montlyExpenses)
        }
    }
    
    var body: some View {
        VStack {
            // ヘッダー
            HeaderView(
                selectedMonth: selectedMonth,
                onChangeMonth: { offset in
                    if let newDate = calendar.date(byAdding: .month, value: offset, to: selectedMonth) {
                        selectedMonth = newDate
                    }
                },
                onTapMonth: {
                    onTapMonth(selectedMonth) { newDate in
                        self.selectedMonth = newDate
                    }
                }
            )
            
            HStack {
                Text("合計支出: ")
                    .font(.headline)
                Text("¥\(monthlyTotal)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            
            // タブ切り替え
            Picker("チャート種類", selection: $selectedChart) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Spacer()
            
            // 円グラフ
            Chart {
                ForEach(currentSlices, id: \.name) { s in
                    SectorMark(angle: .value("金額", s.value), innerRadius: .ratio(0.5))
                        .foregroundStyle(s.color)
                        .annotation(position: .overlay) {
                            let totalSum = currentSlices.reduce(0) { $0 + $1.value }
                            let ratio = s.value / totalSum
                            if ratio >= 0.1 {
                                Text(s.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(2)
                            }
                        }
                }
            }
            .frame(height: 250)
            .padding()

            
            Spacer()
            // カテゴリ/支払い方法ごとの一覧
            List {
                ForEach(currentSlices, id: \.name) { slice in
                    HStack {
                        Image(systemName: slice.icon)
                            .foregroundColor(slice.color)
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 4)
                        Text(slice.name)
                        Spacer()
                        HStack(spacing: 8) {
                            Text("¥\(Int(slice.value))")
                                .frame(minWidth: 80, alignment: .trailing)
                            Text(String(format: "%.1f%%", slice.value / Double(monthlyTotal) * 100))
                                .foregroundColor(.gray)
                                .frame(width: 60, alignment: .trailing)
                        }
                    }
                }
            }
        }
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
    
    private func aggregateCategoryRealm(_ data: [Expense]? = nil) -> [PieSlice] {
        let base = data ?? Array(expenses)
        let grouped = Dictionary(grouping: base) { $0.category?.name ?? "未分類" }
        return grouped.compactMap { name, vals in
            let totalInt = vals.reduce(0) { $0 + $1.amount }
            let hex = vals.first?.category?.colorHex ?? "#CCCCCC"
            let icon = vals.first?.category?.iconName ?? "circle.fill"
            return PieSlice(name: name, value: Double(totalInt), color: Color(hex: hex), icon: icon)
        }.sorted { $0.value > $1.value }
    }
    
    private func aggregatePaymentMethodRealm(_ data: [Expense]? = nil) -> [PieSlice] {
        let base = data ?? Array(expenses)
        let grouped = Dictionary(grouping: base) { $0.paymentMethod?.name ?? "未分類" }
        return grouped.compactMap { name, vals in
            let totalInt = vals.reduce(0) { $0 + $1.amount }
            let hex = vals.first?.paymentMethod?.colorHex ?? "#CCCCCC"
            let icon = vals.first?.paymentMethod?.iconName ?? "circle.fill"
            return PieSlice(name: name, value: Double(totalInt), color: Color(hex: hex), icon: icon)
        }.sorted { $0.value > $1.value }
    }

}
