import SwiftUI

enum ActivePickerMode {
    case date
    case yearMonth
}

struct CustomPicker: View {
    @Binding var showPicker: Bool
    @Binding var savedDate: Date
    let mode: ActivePickerMode
    var onSelected: ((Date) -> Void)? = nil
    
    @State private var selectedDate: Date = Date()
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    
    private let years: [Int]
    private let months = Array(1...12)
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(showPicker: Binding<Bool>, savedDate: Binding<Date>, mode: ActivePickerMode, onSelected: ((Date) -> Void)? = nil) {
        _showPicker = showPicker
        _savedDate = savedDate
        self.mode = mode
        self.onSelected = onSelected
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: savedDate.wrappedValue)
        let month = calendar.component(.month, from: savedDate.wrappedValue)
        
        _selectedDate = State(initialValue: savedDate.wrappedValue)
        _selectedYear = State(initialValue: year)
        _selectedMonth = State(initialValue: month)
        
        years = Array(2000...(year + 10))
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { showPicker = false }
                }
            
            VStack {
                Spacer()
                
                VStack {
                    // ボタンバー
                    HStack {
                        Button("キャンセル") {
                            withAnimation { showPicker = false }
                        }
                        .padding(.trailing, 30)
                        
                        Button(mode == .date ? "今日" : "今月") {
                            let now = Date()
                            let calendar = Calendar.current
                            
                            if mode == .date {
                                selectedDate = now
                            } else {
                                selectedYear = calendar.component(.year, from: now)
                                selectedMonth = calendar.component(.month, from: now)
                            }
                        }
                        
                        Spacer()
                        
                        Button("OK") {
                            if mode == .date {
                                savedDate = selectedDate
                                onSelected?(selectedDate)
                            } else {
                                let calendar = Calendar.current
                                if let newDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)) {
                                    savedDate = newDate
                                    onSelected?(newDate)
                                }
                            }
                            withAnimation { showPicker = false }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color(UIColor.systemGray6))
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    
                    // ピッカー本体
                    if mode == .date {
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(height: 200)
                    } else {
                        HStack(spacing: 0) {
                            Picker("", selection: $selectedYear) {
                                ForEach(years, id: \.self) { year in
                                    Text("\(String(year))年").tag(year)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .pickerStyle(.wheel)
                            
                            Picker("", selection: $selectedMonth) {
                                ForEach(months, id: \.self) { month in
                                    Text("\(month)月").tag(month)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .pickerStyle(.wheel)
                        }
                        .frame(height: 200)
                    }
                }
                .background(colorScheme == .dark ? Color.black : Color.white)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showPicker)
            }
        }
    }
}
