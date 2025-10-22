//
//  MenuView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI

struct MenuView: View {
    @State var showDatePicker: Bool = false
    @State var savedDate: Date = Date()
    @State private var showCalculator: Bool = false
    @State private var amountString: String = ""
    
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BackupView()) {
                    Label("データのバックアップ・復元", systemImage: "square.and.arrow.up.on.square")
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                
                HStack {
                    Label("ダークモード", systemImage: "moon.fill")
                        .font(.headline)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { appTheme == .dark },
                        set: { appTheme = $0 ? .dark : .light }
                    ))
                    .labelsHidden()
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("メニュー")
        }
    }
}
