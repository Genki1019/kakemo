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
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("データのバックアップ・復元") {
                    BackupView()
                }
            }
            .navigationTitle("メニュー")
        }
    }
}

#Preview {
    MenuView()
}
