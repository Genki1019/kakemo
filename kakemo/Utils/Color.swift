//
//  Color.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/06.
//
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {hex.removeFirst()}
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        if hex.count == 6 {
            r = (int >> 16) & 0xFF
            g = (int >> 8) & 0xFF
            b = int & 0xFF
        } else {
            r = 0; g = 0; b = 0
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: 1)
    }
    
    func toHex(includeAlpha: Bool = false) -> String? {
#if canImport(UIKit)
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X",
                          Int(round(r * 255)),
                          Int(round(g * 255)),
                          Int(round(b * 255)),
                          Int(round(a * 255)))
        } else {
            return String(format: "#%02X%02X%02X",
                          Int(round(r * 255)),
                          Int(round(g * 255)),
                          Int(round(b * 255)))
        }
#elseif canImport(AppKit)
        let ns = NSColor(self)
        guard let rgb = ns.usingColorSpace(.deviceRGB) else { return nil }
        let r = rgb.redComponent, g = rgb.greenComponent, b = rgb.blueComponent, a = rgb.alphaComponent
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X",
                          Int(round(r * 255)),
                          Int(round(g * 255)),
                          Int(round(b * 255)),
                          Int(round(a * 255)))
        } else {
            return String(format: "#%02X%02X%02X",
                          Int(round(r * 255)),
                          Int(round(g * 255)),
                          Int(round(b * 255)))
        }
#else
        return nil
#endif
    }
}
