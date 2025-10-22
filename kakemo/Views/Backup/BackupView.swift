//
//  BackupView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/10/08.
//

import SwiftUI
import RealmSwift

struct BackupView: View {
    @ObservedResults(Expense.self) var expenses
    @ObservedResults(Category.self) var categories
    @ObservedResults(PaymentMethod.self) var paymentMethods
    
    @State private var exportURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("データのバックアップ・復元")
                    .font(.title2)
                    .bold()
                
                // 出力ボタン
                Button(action: exportCSV) {
                    Label("データを出力する", systemImage: "square.and.arrow.up.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                
                // 出力完了後の共有ボタン
                if let exportURL {
                    ShareLink(item: exportURL) {
                        Label("作成したCSVを共有／保存", systemImage: "square.and.arrow.up.on.square.fill")
                    }
                }
                
                Divider().padding(.vertical, 10)
                
                Text("復元方法")
                    .font(.headline)
                Text("""
                1. バックアップしたCSVファイルをファイルアプリなどで開きます。
                2. 共有メニューからこのアプリ（kakemo）を選択します。
                3. 「このデータから復元しますか？」という確認が出たら「はい」を選択してください。
                """)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            }
            .padding()
        }
        .navigationTitle("データバックアップ")
    }
    
    // CSV出力処理
    func exportCSV() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var csv = "type,id,date,amount,memo,categoryId,paymentMethodId,name,iconName,colorHex,order\n"
        
        // Category
        for c in categories {
            csv += "category,\(c.id.stringValue),,,,,,\(escape(c.name)),\(escape(c.iconName)),\(escape(c.colorHex)),\(c.order)\n"
        }
        
        // PaymentMethod
        for p in paymentMethods {
            csv += "paymentMethod,\(p.id.stringValue),,,,,,\(escape(p.name)),\(escape(p.iconName)),\(escape(p.colorHex)),\(p.order)\n"
        }
        
        // Expense
        for e in expenses {
            let dateStr = dateFormatter.string(from: e.date)
            csv += "expense,\(e.id.stringValue),\(dateStr),\(e.amount),\(escape(e.memo ?? "")),\(e.category?.id.stringValue ?? ""),\(e.paymentMethod?.id.stringValue ?? ""),,,,\n"
        }
        
        // ファイル名（日付を安全に扱う）
        let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
            .replacingOccurrences(of: "/", with: "-") // ← ここ重要！
        let filename = "kakemo_backup_\(dateString).csv"
        
        // 保存先（サブフォルダを使わず安全に）
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            // 親ディレクトリを作成（ない場合に備えて）
            let dirURL = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
            
            // CSV書き込み
            try csv.write(to: url, atomically: true, encoding: .utf8)
            exportURL = url
            print("✅ CSV出力成功: \(url)")
        } catch {
            print("❌ CSV書き込み失敗: \(error)")
        }
    }

    
    // CSVエスケープ処理
    func escape(_ text: String) -> String {
        if text.contains(",") || text.contains("\"") || text.contains("\n") {
            return "\"\(text.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return text
    }
}


#Preview {
    BackupView()
}
