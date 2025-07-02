//
//  HistoryView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines the view for displaying food history.

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct HistoryView: View {
    @ObservedObject var foodStore: FoodDataStore
    @State private var selectedDate: Date = Date()
    @State private var showingCalendar = false
    @State private var showingEditSheet = false
    @State private var selectedEntryForEdit: BabyFoodEntry?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with cute styling
                    VStack(spacing: 8) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                            .padding(.bottom, 5)
                        
                        Text("Food History")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Track your baby's food journey! 📅")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Calendar Section
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("Calendar View")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        // Simple Calendar View
                        SimpleCalendarView(
                            selectedDate: $selectedDate,
                            foodStore: foodStore
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                    
                    // Food entries for selected date
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "list.bullet.circle")
                                .foregroundColor(.orange)
                                .font(.title2)
                            Text("Entries for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        let todaysEntries = foodStore.getEntriesForDate(selectedDate)
                        
                        if todaysEntries.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "fork.knife.circle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.orange.opacity(0.6))
                                
                                Text("No entries for this date!")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text("Add your first food entry in the Add Entry tab")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.orange.opacity(0.1))
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                            )
                        } else {
                            // Daily Summary
                            DailySummaryCard(entries: todaysEntries)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(todaysEntries) { entry in
                                    FoodEntryCard(
                                        entry: entry,
                                        onDelete: {
                                            foodStore.deleteEntry(withId: entry.id)
                                        },
                                        onEdit: {
                                            selectedEntryForEdit = entry
                                            showingEditSheet = true
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .orange.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.orange.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditSheet) {
                if let entry = selectedEntryForEdit {
                    EditEntryView(foodStore: foodStore, entry: entry)
                }
            }
        }
    }
}

struct SimpleCalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var foodStore: FoodDataStore
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 15) {
            // Month and Year header
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Days of week header
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasEntries: !foodStore.getEntriesForDate(date).isEmpty
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var daysInMonth: [Date?] {
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: selectedDate)?.count ?? 30
        
        var days: [Date?] = []
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days in the month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasEntries: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(width: 40, height: 40)
                
                VStack(spacing: 2) {
                    Text(dateFormatter.string(from: date))
                        .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    if hasEntries {
                        Circle()
                            .fill(isSelected ? Color.white : Color.orange)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DailySummaryCard: View {
    let entries: [BabyFoodEntry]
    
    private var totalAmount: Double {
        entries.reduce(0) { $0 + $1.amount }
    }
    
    private var categoryBreakdown: [FoodCategory: Int] {
        var breakdown: [FoodCategory: Int] = [:]
        for entry in entries {
            breakdown[entry.foodCategory, default: 0] += 1
        }
        return breakdown
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
                Text("Daily Summary")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(entries.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "%.1f", totalAmount))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Total Amount")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if !categoryBreakdown.isEmpty {
                Text("Categories:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(Array(categoryBreakdown.keys), id: \.self) { category in
                        HStack {
                            Text(category.icon)
                            Text("\(categoryBreakdown[category] ?? 0)")
                                .fontWeight(.medium)
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.purple.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct FoodEntryCard: View {
    let entry: BabyFoodEntry
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Photo or placeholder
            if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pink.opacity(0.3), lineWidth: 2)
                    )
            } else {
                VStack {
                    Text(entry.foodCategory.icon)
                        .font(.title2)
                    Text(entry.foodCategory.rawValue)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                )
            }
            
            // Entry details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(entry.foodName)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if entry.isFromLibrary {
                        Image(systemName: "book.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.pink)
                    Text(entry.date, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if entry.amount > 0 {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text("\(String(format: "%.1f", entry.amount)) \(entry.amountUnit.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let notes = entry.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue.opacity(0.8))
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red.opacity(0.8))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(foodStore: FoodDataStore())
    }
}
