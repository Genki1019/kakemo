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
    @State private var importURL: ImportFile?
    
    @AppStorage("appTheme") private var appTheme: AppTheme = .system

    init() {
        _ = RealmManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme(for: appTheme))
                .onOpenURL { url in
                    if url.pathExtension == "csv" {
                        importURL = ImportFile(url: url)
                    }
                }
                .sheet(item: $importURL) { file in
                    CSVImportConfirmView(fileURL: file.url)
                }
        }
    }
    
    private func colorScheme(for theme: AppTheme) -> ColorScheme? {
        switch theme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct ImportFile: Identifiable {
    let id = UUID()
    let url: URL
}
