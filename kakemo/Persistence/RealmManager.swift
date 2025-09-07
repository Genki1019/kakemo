//
//  RealmManager.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
    
    private init() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true
        )
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
        
        setupDefaultCategories()
        setupDefaultPaymentMethods()
    }
    
    func getRealm() -> Realm {
        return realm
    }
    
    private func setupDefaultCategories() {
        if !realm.objects(Category.self).isEmpty { return }
        
        let defaults = [
            Category(value: ["name": "食費", "iconName": "cart", "colorHex": "#FF7043", "order": 0]),
            Category(value: ["name": "日用雑貨", "iconName": "bag", "colorHex": "#8D6E63", "order": 1]),
            Category(value: ["name": "衣服", "iconName": "tshirt", "colorHex": "#42A5F5", "order": 2]),
            Category(value: ["name": "美容", "iconName": "scissors", "colorHex": "#EC407A", "order": 3]),
            Category(value: ["name": "交際費", "iconName": "person.2", "colorHex": "#7E57C2", "order": 4]),
            Category(value: ["name": "趣味", "iconName": "gamecontroller", "colorHex": "#66BB6A", "order": 5]),
            Category(value: ["name": "医療費", "iconName": "cross", "colorHex": "#EF5350", "order": 6]),
            Category(value: ["name": "教育費", "iconName": "book", "colorHex": "#29B6F6", "order": 7]),
            Category(value: ["name": "家賃", "iconName": "house", "colorHex": "#AB47BC", "order": 8]),
            Category(value: ["name": "光熱費", "iconName": "lightbulb", "colorHex": "#FFCA28", "order": 9]),
            Category(value: ["name": "交通費", "iconName": "car", "colorHex": "#26A69A", "order": 10]),
            Category(value: ["name": "通信費", "iconName": "wifi", "colorHex": "#5C6BC0", "order": 11]),
            Category(value: ["name": "その他", "iconName": "star", "colorHex": "#9E9E9E", "order": 12])
        ]
        
        try! realm.write {
            realm.add(defaults)
        }
        print("デフォルトカテゴリを追加しました")
    }
    
    private func setupDefaultPaymentMethods() {
        if !realm.objects(PaymentMethod.self).isEmpty { return }
        
        let defaults = [
            PaymentMethod(value: ["name": "現金", "iconName": "banknote", "colorHex": "#4CAF50", "order": 0]),
            PaymentMethod(value: ["name": "クレジット", "iconName": "creditcard", "colorHex": "#1976D2", "order": 1]),
            PaymentMethod(value: ["name": "引き落とし", "iconName": "building.columns", "colorHex": "#6D4C41", "order": 2]),
            PaymentMethod(value: ["name": "QR決済", "iconName": "qrcode", "colorHex": "#E53935", "order": 3]),
            PaymentMethod(value: ["name": "その他", "iconName": "star", "colorHex": "#9E9E9E", "order": 4])
        ]
        
        try! realm.write {
            realm.add(defaults)
        }
        print("デフォルト支払い方法を追加しました")
    }
}
