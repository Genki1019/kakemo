//
//  kakemoApp.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/05.
//

import SwiftUI
import RealmSwift

@main
struct kakemoApp: SwiftUI.App {
    init() {
        _ = RealmManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
