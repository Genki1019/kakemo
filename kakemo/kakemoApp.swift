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

    init() {
        _ = RealmManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
}

struct ImportFile: Identifiable {
    let id = UUID()
    let url: URL
}
