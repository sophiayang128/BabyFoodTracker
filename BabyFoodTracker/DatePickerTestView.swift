//
//  DatePickerTestView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines a test view for testing the DatePicker component in isolation.

import SwiftUI

struct DatePickerTestView: View {
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 40))
                        .foregroundColor(.pink)
                        .padding(.bottom, 5)
                    
                    Text("DatePicker Test")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Test the DatePicker component in isolation")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // DatePicker Section (copied from AddEntryView)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.pink)
                            .font(.title2)
                        Text("When did baby eat?")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }

                    let minDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
                    let maxDate = Calendar.current.date(byAdding: .year, value: 100, to: Date())!
                    
                    DatePicker("Date and Time", selection: $selectedDate, in: minDate...maxDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                        .environment(\.locale, Locale(identifier: "en_US"))
                        .onChange(of: selectedDate) { oldDate, newDate in
                            print("📅 DatePickerTestView DatePicker changed - Old: \(dateFormatter.string(from: oldDate)) -> New: \(dateFormatter.string(from: newDate))")
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.pink.opacity(0.1))
                        )
                        .padding(.horizontal, 5)
                    
                    // Display the selected date to confirm binding is working
                    Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .pink.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                
                // Test Controls
                VStack(spacing: 15) {
                    Text("Test Controls")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 15) {
                        Button("Set to Today") {
                            selectedDate = Date()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.pink)
                        
                        Button("Set to Yesterday") {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.pink)
                    }
                    
                    HStack(spacing: 15) {
                        Button("Set to Last Week") {
                            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.pink)
                        
                        Button("Set to Next Week") {
                            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.pink)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                )
                
                // Debug Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Debug Information")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Current Date: \(Date(), formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Date Range: \(minDate, formatter: dateFormatter) to \(maxDate, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.1))
                )
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.05), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
        }
    }
    
    // Date Formatter for displaying selected date
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    // Computed properties for date range
    private var minDate: Date {
        Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    }
    
    private var maxDate: Date {
        Calendar.current.date(byAdding: .year, value: 100, to: Date())!
    }
}

struct DatePickerTestView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerTestView()
    }
} 