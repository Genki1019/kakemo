//
//  CalculatorInputView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/30.
//

import SwiftUI

struct CalculatorInputView: View {
    @Binding var showCalculator: Bool
    var initialValue: Int
    var onUpdate: (Int) -> Void
    
    @State private var expression: String = ""
    @State private var showEqual: Bool = false
    @State private var selectedOperator: String? = nil
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(showCalculator: Binding<Bool>, initialValue: Int, onUpdate: @escaping (Int) -> Void) {
        self._showCalculator = showCalculator
        self.initialValue = initialValue
        self.onUpdate = onUpdate
        self._expression = State(initialValue: "\(initialValue)")
    }
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation { showCalculator = false }
                }
            
            VStack {
                Spacer()
                
                VStack {
                    // 税率・閉じるボタンバー
                    HStack {
                        Button("税率 8%") {
                            if let value = evaluateExpression() {
                                let taxed = Int(Double(value) * 1.08)
                                expression = "\(taxed)"
                                onUpdate(taxed)
                            }
                        }
                        .padding(.horizontal)
                        
                        Button("税率 10%") {
                            if let value = evaluateExpression() {
                                let taxed = Int(Double(value) * 1.1)
                                expression = "\(taxed)"
                                onUpdate(taxed)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button("閉じる") {
                            withAnimation { showCalculator = false }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color(colorScheme == .dark ? UIColor.systemGray5 : UIColor.systemGray6))
                    
                    // 電卓ボタン
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            calcButton("7")
                            calcButton("8")
                            calcButton("9")
                            calcButton("÷")
                            calcButton("AC")
                        }
                        
                        HStack(spacing: 10) {
                            calcButton("4")
                            calcButton("5")
                            calcButton("6")
                            calcButton("×")
                            calcButton("Del")
                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            VStack(spacing: 10) {
                                HStack(spacing: 10) {
                                    calcButton("1")
                                    calcButton("2")
                                    calcButton("3")
                                    calcButton("-")
                                }
                                HStack(spacing: 10) {
                                    calcButton("0")
                                    calcButton("00", isWide: true)
                                    calcButton("+")
                                }
                            }
                            
                            calcButton(showEqual ? "=" : "OK", isTall: true)
                        }
                    }
                    .background(colorScheme == .dark ? Color.black : Color.white)
                }
                .background(colorScheme == .dark ? Color.black : Color.white)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showCalculator)
            }
        }
    }
    
    // 共通ボタン
    @ViewBuilder
    private func calcButton(_ label: String, isWide: Bool = false, isTall: Bool = false) -> some View {
        let isOperator = ["+", "-", "×", "÷"].contains(label)
        let isDel = label == "Del"
        let isOK = label == "OK" || label == "="
        
        let bgColor: Color = {
            if isOperator {
                return selectedOperator == label
                ? (colorScheme == .dark ? Color.blue.opacity(0.9) : .blue.opacity(0.8))
                : (colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5))
            }
            return colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5)
        }()
        
        let textColor: Color = {
            if isDel { return .red }
            if isOK { return .blue }
            if isOperator {
                return selectedOperator == label ? .white : (colorScheme == .dark ? .white : Color(.darkGray))
            }
            return colorScheme == .dark ? .white : Color(.darkGray)
        }()
        
        Button(action: { handleInput(label) }) {
            Text(label)
                .frame(
                    width: isWide ? 130 : 60,
                    height: isTall ? 130 : 60
                )
                .background(bgColor)
                .foregroundColor(textColor)
                .cornerRadius(12)
        }
    }
    
    // 入力処理
    private func handleInput(_ input: String) {
        switch input {
        case "AC":
            expression = ""
            showEqual = false
            selectedOperator = nil
            onUpdate(0)
            
        case "Del":
            if !expression.isEmpty {
                expression.removeLast()
                
                if let lastOpRange = expression.range(of: "[+\\-×÷]", options: .regularExpression) {
                    let rightSide = String(expression[lastOpRange.upperBound...])
                    if !rightSide.isEmpty {
                        if let val = Int(rightSide) {
                            onUpdate(val)
                        } else {
                            onUpdate(0)
                        }
                        return
                    }
                }
                
                if let value = evaluateExpression() {
                    onUpdate(value)
                } else {
                    onUpdate(0)
                }
            } else {
                onUpdate(0)
                selectedOperator = nil
            }
            
        case "OK", "=":
            if let result = evaluateExpression() {
                expression = "\(result)"
                onUpdate(result)
            }
            selectedOperator = nil
            showEqual = false
            if input == "OK" {
                withAnimation { showCalculator = false }
            }
            
        case "+", "-", "×", "÷":
            if let last = expression.last, "+-×÷".contains(last) {
                expression.removeLast()
                expression.append(input)
                selectedOperator = input
                return
            }
            
            if let result = evaluateExpression() {
                expression = "\(result)\(input)"
                onUpdate(result)
            } else {
                expression.append(input)
            }
            selectedOperator = input
            showEqual = true
            
        default:
            expression.append(input)
            
            if let lastOpRange = expression.range(of: "[+\\-×÷]", options: .regularExpression, range: nil, locale: nil) {
                let rightSide = String(expression[lastOpRange.upperBound...])
                if let val = Int(rightSide), !rightSide.isEmpty {
                    onUpdate(val)
                }
            } else {
                if let value = evaluateExpression() {
                    onUpdate(value)
                }
            }
            
            showEqual = true
        }
    }
    
    // 計算実行
    private func evaluateExpression() -> Int? {
        guard !expression.isEmpty else { return 0 }
        
        if let last = expression.last, "+-×÷".contains(last) { return nil }
        
        let cleaned = expression
            .filter { "0123456789+-×÷*/.".contains($0) }
        
        let replaced = cleaned
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        guard replaced.range(of: #"^[0-9+\-*/.]+$"#, options: .regularExpression) != nil else {
            return nil
        }
        
        let exp = NSExpression(format: replaced)
        if let result = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            return Int(truncating: result)
        }
        return nil
    }
}
