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
        
        // デバッグ用
//        try! realm.write {
//            realm.deleteAll()
//        }
        
        setupDefaultCategories()
        setupDefaultPaymentMethods()
    }
    
    func getRealm() -> Realm {
        return realm
    }
    
    private func setupDefaultCategories() {
        if !realm.objects(Category.self).isEmpty { return }
        
        let defaults = [
            Category(value: ["name": "食費", "iconName": "cart", "colorHex": "#FE8700", "order": 0]),
            Category(value: ["name": "日用雑貨", "iconName": "bag", "colorHex": "#66B0FD", "order": 1]),
            Category(value: ["name": "衣服", "iconName": "tshirt", "colorHex": "#1638A5", "order": 2]),
            Category(value: ["name": "美容", "iconName": "scissors", "colorHex": "#FD53A7", "order": 3]),
            Category(value: ["name": "交際費", "iconName": "person.2", "colorHex": "#E2FE66", "order": 4]),
            Category(value: ["name": "趣味", "iconName": "gamecontroller", "colorHex": "#4FD800", "order": 5]),
            Category(value: ["name": "医療費", "iconName": "cross", "colorHex": "#5FE395", "order": 6]),
            Category(value: ["name": "教育費", "iconName": "book", "colorHex": "#FE4950", "order": 7]),
            Category(value: ["name": "家賃", "iconName": "house", "colorHex": "#B5026B", "order": 8]),
            Category(value: ["name": "光熱費", "iconName": "lightbulb", "colorHex": "#FEE100", "order": 9]),
            Category(value: ["name": "交通費", "iconName": "car", "colorHex": "#A9663C", "order": 10]),
            Category(value: ["name": "通信費", "iconName": "wifi", "colorHex": "#E0C2FF", "order": 11]),
            Category(value: ["name": "その他", "iconName": "star", "colorHex": "#980AA6", "order": 12])
        ]
        
        try! realm.write {
            realm.add(defaults)
        }
        print("デフォルトカテゴリを追加しました")
    }
    
    private func setupDefaultPaymentMethods() {
        if !realm.objects(PaymentMethod.self).isEmpty { return }
        
        let defaults = [
            PaymentMethod(value: ["name": "現金", "iconName": "banknote", "colorHex": "#66B0FD", "order": 0]),
            PaymentMethod(value: ["name": "クレジット", "iconName": "creditcard", "colorHex": "#FEE100", "order": 1]),
            PaymentMethod(value: ["name": "引き落とし", "iconName": "building.columns", "colorHex": "#A9663C", "order": 2]),
            PaymentMethod(value: ["name": "QR決済", "iconName": "qrcode", "colorHex": "#FE4950", "order": 3]),
            PaymentMethod(value: ["name": "その他", "iconName": "star", "colorHex": "#980AA6", "order": 4])
        ]
        
        try! realm.write {
            realm.add(defaults)
        }
        print("デフォルト支払い方法を追加しました")
    }
}
