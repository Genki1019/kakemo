//
//  MainView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI

enum ActivePicker {
    case date
    case yearMonth
}

struct MainView: View {
    @State private var activePicker: ActivePicker? = nil
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            TabView {
                ExpenseFormView(
                    date: $selectedDate,
                    onTapDate: { activePicker = .date }
                )
                    .tabItem {
                        Label("入力", systemImage: "pencil")
                    }
                ExpenseListView(
                    selectedMonth: $selectedDate,
                    onTapMonth: { activePicker = .yearMonth },
                    onChangeMonth: { offset in
                        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: selectedDate) {
                            selectedDate = newDate
                        }
                    }
                )
                    .tabItem {
                        Label("カレンダー", systemImage: "calendar")
                    }
                ReportView(
                    selectedMonth: $selectedDate,
                    onTapMonth: { activePicker = .yearMonth },
                    onChangeMonth: { offset in
                        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: selectedDate) {
                            selectedDate = newDate
                        }
                    }
                )
                    .tabItem {
                        Label("レポート", systemImage: "chart.pie")
                    }
                MenuView()
                    .tabItem {
                        Label("メニュー", systemImage: "ellipsis")
                    }
                }
            if let picker = activePicker {
                CustomPicker(
                    showPicker: Binding(
                        get: { activePicker != nil },
                        set: { if !$0 { activePicker = nil } }
                    ),
                    savedDate: $selectedDate,
                    mode: picker == .date ? .date : .yearMonth
                )
                .zIndex(1)
            }
        }
    }
}

#Preview {
    MainView()
}
