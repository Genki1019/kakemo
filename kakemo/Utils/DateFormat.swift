//
//  DateFormat.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/09.
//

import Foundation

extension Date {
    /// 共通の日付フォーマット: yyyy年M月d日(E)
    var dayTitleString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E)"
        return formatter.string(from: self)
    }
    
    /// 共通の月フォーマット: yyyy年M月
    var monthTitleString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: self)
    }
}
