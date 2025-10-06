//
//  CalculatorInputView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/30.
//

import SwiftUI

struct CalculatorInputView: View {
    @Binding var showCalculator: Bool
    var onUpdate: (Int) -> Void
    
    @State private var expression: String = ""
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        VStack {
            // 上部ボタンバー
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
            .background(Color(UIColor.systemGray6))
            
            // 電卓ボタン
            VStack(spacing: 8) {
                // 1行目
                HStack(spacing: 8) {
                    calcButton("7")
                    calcButton("8")
                    calcButton("9")
                    calcButton("÷")
                    calcButton("AC")
                }
                
                // 2行目
                HStack(spacing: 10) {
                    calcButton("4")
                    calcButton("5")
                    calcButton("6")
                    calcButton("×")
                    calcButton("Del")
                }
                
                // 3〜4行目をまとめて、右端にOKを縦2段配置
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
                    
                    // OK ボタンを縦に2マスぶんの高さに
                    calcButton("OK", isTall: true)
                }
            }


            .padding()
            .background(Color.white)
        }
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: showCalculator)
    }
    
    // 共通ボタン
    @ViewBuilder
    private func calcButton(_ label: String, isWide: Bool = false, isTall: Bool = false) -> some View {
        Button(action: { handleInput(label) }) {
            Text(label)
                .frame(
                    width: isWide ? 130 : 60,   // 横に広いボタン
                    height: isTall ? 130 : 60   // 縦に長いボタン
                )
                .background(Color.orange.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .gridCellColumns(isWide ? 2 : 1)
    }
    
    // 入力処理
    private func handleInput(_ input: String) {
        switch input {
        case "AC":
            expression = ""
            onUpdate(0)
        case "Del":
            if !expression.isEmpty {
                expression.removeLast()
            }
            sendResult()
        case "OK":
            withAnimation { showCalculator = false }
        case "+", "-", "×", "÷":
            if let last = expression.last, "+-×÷".contains(last) {
                expression.removeLast()
            }
            expression.append(input)
        default:
            expression.append(input)
        }
        sendResult()
    }
    
    // 計算して反映
    private func sendResult() {
        if let result = evaluateExpression() {
            onUpdate(result)
        }
    }
    
    // 計算実行
    private func evaluateExpression() -> Int? {
        guard !expression.isEmpty else { return 0 }
        
        if let last = expression.last, "+-×÷".contains(last) {
            return nil
        }
        
        let replaced = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        let exp = NSExpression(format: replaced)
        if let result = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            return Int(truncating: result)
        }
        return nil
    }
}
