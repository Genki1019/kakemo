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
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    showDatePicker.toggle()
                } label: {
                    Text(savedDate.dayTitleString)
                    Image(systemName: "calendar")
                }
                .buttonStyle(.bordered)
            }
            if showDatePicker {
                CustomDatePicker(
                    showDatePicker: $showDatePicker,
                    savedDate: $savedDate,
                    selectedDate: savedDate
                )
                .animation(.linear, value: savedDate)
                .transition(.opacity)
            }
        }
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

//#Preview {
//    MenuView()
//}
