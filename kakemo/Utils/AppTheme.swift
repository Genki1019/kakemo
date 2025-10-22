//
//  AppTheme.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/10/22.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "システムに合わせる"
        case .light: return "ライトモード"
        case .dark: return "ダークモード"
        }
    }
}
