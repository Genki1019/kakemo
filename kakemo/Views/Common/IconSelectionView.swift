//
//  IconSelectionView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/13.
//

import SwiftUI

struct IconSelectionView: View {
    @Binding var selectedIcon: String?
    let icons: [String]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(icons, id: \.self) { icon in
                Button {
                    selectedIcon = icon
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedIcon == icon ? Color.accentColor : Color.gray.opacity(0.3),
                                    lineWidth: selectedIcon == icon ? 2 : 1)
                            .frame(height: 60)
                        
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
