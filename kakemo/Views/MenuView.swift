//
//  MenuView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI

struct MenuView: View {
    @State var showDatePicker: Bool = false
    @State var savedDate: Date = Date()
    
    @State private var showCalculator: Bool = false
    @State private var amountString: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                TextField("金額", text: $amountString)
                    .disabled(true) // 入力禁止
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                // 透明ボタンでタップ可能にする
                Rectangle()
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            showCalculator = true
                        }
                    }
            }
            
            if showCalculator {
                CalculatorInputView(
                    showCalculator: $showCalculator,
                    initialValue: Int(amountString) ?? 0
                ) { result in
                    amountString = "\(result)"
                }
                .transition(.move(edge: .bottom))
            }
        }
        .padding()
    }
}

struct CustomDatePicker: View {
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showDatePicker = false
                }
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Button("キャンセル") {
                            showDatePicker = false
                        }
                        .padding(.trailing, 30)
                        Button("今日") {
                            selectedDate = Date()
                        }
                        Spacer()
                        Button("OK") {
                            savedDate = selectedDate
                            showDatePicker = false
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color(UIColor.systemGray6))
                    
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                }
                .background(.white)
            }
        }
    }
}

#Preview {
    MenuView()
}
