//
//  CSVImportConfirmView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/10/09.
//

import SwiftUI
import RealmSwift

struct CSVImportConfirmView: View, Identifiable {
    var id: URL { fileURL }
    let fileURL: URL
    @Environment(\.dismiss) var dismiss
    @Environment(\.realm) var realm
    @State private var showingAlert = true
    

    var body: some View {
        Text("CSVデータを検出しました。復元しますか？")
            .alert("CSVデータの復元", isPresented: $showingAlert) {
                Button("キャンセル", role: .cancel) {
                    dismiss()
                }
                Button("はい", role: .destructive) {
                    importCSV()
                    dismiss()
                }
            } message: {
                Text("既存データはすべて削除され、新しいデータに置き換えられます。")
            }
    }
    
    func importCSV() {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.split(separator: "\n").dropFirst() // ヘッダー除外
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            try realm.write {
                realm.deleteAll()
                
                var categoryMap: [String: Category] = [:]
                var paymentMap: [String: PaymentMethod] = [:]
                
                for line in lines {
                    let fields = parseCSVLine(String(line))
                    guard fields.count >= 11 else { continue }
                    let type = fields[0]
                    
                    switch type {
                    case "category":
                        let c = Category()
                        c.id = try! ObjectId(string: fields[1])
                        c.name = fields[7]
                        c.iconName = fields[8]
                        c.colorHex = fields[9]
                        c.order = Int(fields[10]) ?? 0
                        realm.add(c)
                        categoryMap[c.id.stringValue] = c
                        
                    case "paymentMethod":
                        let p = PaymentMethod()
                        p.id = try! ObjectId(string: fields[1])
                        p.name = fields[7]
                        p.iconName = fields[8]
                        p.colorHex = fields[9]
                        p.order = Int(fields[10]) ?? 0
                        realm.add(p)
                        paymentMap[p.id.stringValue] = p
                        
                    case "expense":
                        let e = Expense()
                        e.id = try! ObjectId(string: fields[1])
                        e.date = df.date(from: fields[2]) ?? Date()
                        e.amount = Int(fields[3]) ?? 0
                        e.memo = fields[4]
                        e.category = categoryMap[fields[5]]
                        e.paymentMethod = paymentMap[fields[6]]
                        realm.add(e)
                    default:
                        break
                    }
                }
            }
        } catch {
            print("CSV読み込み失敗: \(error)")
        }
    }
    
    func parseCSVLine(_ line: String) -> [String] {
        var result: [String] = []
        var current = ""
        var insideQuotes = false
        
        for char in line {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                result.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }
        result.append(current)
        return result.map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
