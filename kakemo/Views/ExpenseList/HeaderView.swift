//
//  HeaderView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/09.
//

import SwiftUI

struct HeaderView: View {
    var selectedMonth: Date
    var monthlyTotal: Int
    var onChangeMonth: (Int) -> Void
    
    
    var body: some View {
        HStack {
            Button(action: { onChangeMonth(-1) }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(selectedMonth.monthTitleString)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Button(action: { onChangeMonth(1) }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }
}
