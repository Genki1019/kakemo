//
//  Category.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var iconName: String = ""
    @Persisted var colorHex: String = ""
    @Persisted var order: Int = 0
}
