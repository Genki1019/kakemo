//
//  ColorSelectionView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/13.
//

import SwiftUI

struct ColorSelectionView: View {
    @Binding var selectedColor: String?
    @Binding var showColorPicker: Bool
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(ColorOptions.colors, id: \.self) { hex in
                Button {
                    selectedColor = hex
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: hex))
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(selectedColor == hex ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                }
            }
            
            Button {
                showColorPicker.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [4]))
                    .frame(height: 40)
                    .overlay(Image(systemName: "plus"))
            }
        }
    }
}
