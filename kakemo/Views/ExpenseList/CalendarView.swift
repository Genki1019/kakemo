//
//  CalendarView.swift
//  kakemo
//
//  Created by Genki Yamamoto on 2025/09/07.
//

import SwiftUI

struct CalendarView: View {
    let selectedMonth: Date
    let totals: [Date: Int]
    private let calendar =  Calendar.current
    
    var body: some View {
        let days = daysInMonth(for: selectedMonth)
                
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                let weekdays = ["日", "月", "火", "水", "木", "金", "土"]
                ForEach(0..<7, id: \.self) { i in
                    Text(weekdays[i])
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(
                            i == 0 ? .red : (i == 6 ? .blue : .primary)
                        )
                }
            }
            .frame(height: 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                ForEach(days.indices, id: \.self) { index in
                    if let day = days[index] {
                        ZStack {
                            Rectangle()
                                .fill(calendar.isDateInToday(day) ? Color.yellow.opacity(0.1) : Color.clear)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                            VStack {
                                HStack {
                                    let weekday = calendar.component(.weekday, from: day)
                                    Text("\(calendar.component(.day, from: day))")
                                        .font(.caption2)
                                        .foregroundColor(weekday == 1 ? .red : (weekday == 7 ? .blue : .primary))
                                        .padding(2)
                                    Spacer()
                                }
                                Spacer()
                                HStack {
                                    if let total = totals[calendar.startOfDay(for: day)], total > 0 {
                                        Spacer()
                                        Text("¥\(total)")
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .frame(height: 40)
                    } else {
                        Rectangle()
                            .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                            .frame(height: 40)
                    }
                }
            }
        }
    }
    
    
    private func daysInMonth(for date: Date) -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }
        
        let daysCount = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day!
        
        var days: [Date?] = []
        
        let leadingEmptyDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        days.append(contentsOf: Array(repeating: nil, count: leadingEmptyDays))
        
        for i in 0..<daysCount {
            if let day = calendar.date(byAdding: .day, value: i, to: monthInterval.start) {
                days.append(day)
            }
        }
        
        let trailingEmptyDays = (7 - (days.count % 7)) % 7
        days.append(contentsOf: Array(repeating: nil, count: trailingEmptyDays))
        
        return days
    }
}
