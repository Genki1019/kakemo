//
//  MainView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            AddExpenseView()
                .tabItem {
                    Label("入力", systemImage: "pencil")
                }
            ExpenseListView()
                .tabItem {
                    Label("カレンダー", systemImage: "calendar")
                }
            ReportView()
                .tabItem {
                    Label("レポート", systemImage: "chart.pie")
                }
            MenuView()
                .tabItem {
                    Label("メニュー", systemImage: "ellipsis")
                }
        }
    }
}

#Preview {
    MainView()
}
