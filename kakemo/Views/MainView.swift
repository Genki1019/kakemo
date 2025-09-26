//
//  MainView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI

enum ActivePicker {
    case date((Date) -> Void, Date)
    case yearMonth((Date) -> Void, Date)
}

struct MainView: View {
    @State private var activePicker: ActivePicker? = nil
    @State private var activeExpenseForm: Expense? = nil
    @State private var initialFormDate: Date = Date()
    @State private var showNewExpenseForm: Bool = false
    
    var body: some View {
        ZStack {
            TabView {
                ExpenseFormView(
                    onTapDate: { current, onSelected in
                        activePicker = .date(onSelected, current)
                    }
                )
                    .tabItem {
                        Label("入力", systemImage: "pencil")
                    }
                ExpenseListView(
                    onTapMonth: { current, onSelected in
                        activePicker = .yearMonth(onSelected, current)
                    },
                    onTapEdit: { expense in
                        activeExpenseForm = expense
                        initialFormDate = expense.date
                    }
                )
                    .tabItem {
                        Label("カレンダー", systemImage: "calendar")
                    }
                ReportView(
                    onTapMonth: { current, onSelected in
                        activePicker = .yearMonth(onSelected, current)
                    }
                )                    .tabItem {
                        Label("レポート", systemImage: "chart.pie")
                    }
                MenuView()
                    .tabItem {
                        Label("メニュー", systemImage: "ellipsis")
                    }
                }
            
            // 新規/編集フォーム
            if showNewExpenseForm || activeExpenseForm != nil {
                ExpenseFormView(
                    editingExpense: activeExpenseForm,
                    initialDate: initialFormDate,
                    showCloseButton: true,
                    isPresented: Binding(
                        get: { showNewExpenseForm || activeExpenseForm != nil },
                        set: { value in
                            if !value {
                                showNewExpenseForm = false
                                activeExpenseForm = nil
                            }
                        }
                    ),
                    onTapDate: { current, onSelected in
                        activePicker = .date(onSelected, current)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 80)
                .edgesIgnoringSafeArea(.all)
                .zIndex(2)
            }
            
            // 日付/年月ピッカー
            if let picker = activePicker {
                switch picker {
                case .date(let onSelected, let current):
                    CustomPicker(
                        showPicker: Binding(
                            get: { activePicker != nil },
                            set: { if !$0 { activePicker = nil } }
                        ),
                        savedDate: .constant(current),
                        mode: .date,
                        onSelected: { newDate in
                            onSelected(newDate)
                            activePicker = nil
                        }
                    )
                    .zIndex(3)
                    
                case .yearMonth(let onSelected, let current):
                    CustomPicker(
                        showPicker: Binding(
                            get: { activePicker != nil },
                            set: { if !$0 { activePicker = nil } }
                        ),
                        savedDate: .constant(current),
                        mode: .yearMonth,
                        onSelected: { newDate in
                            onSelected(newDate)
                            activePicker = nil
                        }
                    )
                    .zIndex(3)
                }
            }
        }
    }
}
