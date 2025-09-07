//
//  Expense.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import RealmSwift
import Foundation

class Expense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var amount: Int = 0
    @Persisted var memo: String?
    @Persisted var category: Category?
    @Persisted var paymentMethod: PaymentMethod?
}
