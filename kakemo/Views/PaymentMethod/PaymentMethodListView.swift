//
//  PaymentMethodListView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import SwiftUI
import RealmSwift

struct PaymentMethodListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedResults(PaymentMethod.self, sortDescriptor: SortDescriptor(keyPath: "order", ascending: true)) var paymentMethods
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: AddPaymentMethodView()) {
                    Label("新規支払い方法を追加", systemImage: "plus.circle")
                }
            }
            
            Section {
                ForEach(Array(paymentMethods), id: \.id) { paymentMethod in
                    NavigationLink(destination: EditPaymentMethodView(paymentMethod: paymentMethod)) {
                        HStack {
                            Image(systemName: paymentMethod.iconName)
                                .foregroundColor(Color(hex: paymentMethod.colorHex))
                            Text(paymentMethod.name)
                        }
                    }
                }
                .onDelete(perform: deletePaymentMethod)
                .onMove(perform: movePaymentMethod)
            }
        }
        .navigationTitle("支払い方法一覧")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    // 削除処理
    private func deletePaymentMethod(at offsets: IndexSet) {
        do {
            let realm = try Realm()
            try realm.write {
                offsets.forEach { index in
                    let pm = paymentMethods[index]
                    if pm.isFrozen {
                        if let livePm = realm.object(ofType: PaymentMethod.self, forPrimaryKey: pm.id) {
                            realm.delete(livePm)
                        }
                    } else {
                        realm.delete(pm)
                    }
                }
            }
        } catch {
            print("Realm delete error:", error)
        }
    }
    
    // 並べ替え処理
    private func movePaymentMethod(from source: IndexSet, to destination: Int) {
        let current = Array(paymentMethods)
        guard let fromIndex = source.first else { return }
        
        let movePm = current[fromIndex]
        let realm = try! Realm()
        
        try? realm.write {
            if fromIndex < destination {
                // 下へ移動する場合
                for i in (fromIndex + 1)...(destination - 1) {
                    let pm = realm.object(ofType: PaymentMethod.self, forPrimaryKey: current[i].id)
                    pm?.order -= 1
                }
                let liveMovePm = realm.object(ofType: PaymentMethod.self, forPrimaryKey: movePm.id)
                liveMovePm?.order = destination - 1
            } else if destination < fromIndex {
                // 上へ移動する場合
                for i in (destination...(fromIndex - 1)).reversed() {
                    let cat = realm.object(ofType: PaymentMethod.self, forPrimaryKey: current[i].id)
                    cat?.order += 1
                }
                let liveMovePm = realm.object(ofType: PaymentMethod.self, forPrimaryKey: movePm.id)
                liveMovePm?.order = destination
            }
        }
    }
}

#Preview {
    NavigationStack {
        PaymentMethodListView()
    }
}
