//
//  PaymentMethodPickerView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/06.
//

import SwiftUI
import RealmSwift

struct PaymentMethodPickerView: View {
    @ObservedResults(PaymentMethod.self, sortDescriptor: SortDescriptor(keyPath: "order", ascending: true)) var paymentMethods
    @Binding var selectedId: ObjectId?
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(paymentMethods) { pm in
                    Button {
                        selectedId = pm.id
                    } label: {
                        VStack {
                            Image(systemName: pm.iconName)
                                .font(.title2)
                                .frame(width:44, height:32)
                                .foregroundColor(Color(hex: pm.colorHex))
                            Text(pm.name)
                                .font(.caption)
                                .foregroundColor(Color(hex: pm.colorHex))
                        }
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    selectedId == pm.id ? Color.gray : Color.gray.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                    }
                }
                
                // 編集/追加ボタン
                NavigationLink(destination: PaymentMethodListView()) {
                    VStack {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .frame(width:44, height:32)
                            .foregroundColor(.gray)
                        Text("編集")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding(6)
        .frame(maxHeight: 200)
    }
}

#Preview {
    PaymentMethodPickerView(selectedId: .constant(nil))
}
