//
//  HeaderView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/09.
//

import SwiftUI

struct HeaderView: View {
    var selectedMonth: Date
    var onChangeMonth: (Int) -> Void
    var onTapMonth: () -> Void
    
    @State private var showMonthPicker = false
    @State private var tempDate: Date = Date()
    
    var body: some View {
        HStack {
            Button {
                onChangeMonth(-1)
            } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Button {
                onTapMonth()
            } label: {
                Text(selectedMonth.monthTitleString)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button {
                onChangeMonth(1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }
}
