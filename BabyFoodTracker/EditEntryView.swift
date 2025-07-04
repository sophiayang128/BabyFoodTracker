//
//  EditEntryView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines the view for editing existing food entries.

import SwiftUI
import PhotosUI
#if canImport(UIKit)
import UIKit
#endif

struct EditEntryView: View {
    @ObservedObject var foodStore: FoodDataStore
    @StateObject private var foodLibrary = FoodLibrary()
    @Environment(\.dismiss) private var dismiss
    
    let entry: BabyFoodEntry
    
    @State private var selectedDate: Date
    @State private var foodName: String
    @State private var selectedCategory: FoodCategory
    @State private var amount: Double
    @State private var selectedUnit: AmountUnit
    @State private var notes: String
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var photoImageData: Data?
    @State private var showFoodLibrary: Bool = false
    @State private var isFromLibrary: Bool
    @State private var selectedLibraryItem: FoodLibraryItem?

    init(foodStore: FoodDataStore, entry: BabyFoodEntry) {
        self.foodStore = foodStore
        self.entry = entry
        
        // Initialize state with current entry values
        _selectedDate = State(initialValue: entry.date)
        _foodName = State(initialValue: entry.foodName)
        _selectedCategory = State(initialValue: entry.foodCategory)
        _amount = State(initialValue: entry.amount)
        _selectedUnit = State(initialValue: entry.amountUnit)
        _notes = State(initialValue: entry.notes ?? "")
        _photoImageData = State(initialValue: entry.photoData)
        _isFromLibrary = State(initialValue: entry.isFromLibrary)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    mainContentView
                }
            }
            .background(backgroundGradient)
            .navigationBarHidden(true)
            .sheet(isPresented: $showFoodLibrary) {
                FoodLibraryView(foodLibrary: foodLibrary, selectedItem: $selectedLibraryItem)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
                .padding(.bottom, 5)
            
            Text("Edit Food Entry")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Update your baby's food record! ✏️")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var mainContentView: some View {
        VStack(spacing: 25) {
            dateTimeSection
            foodSelectionSection
            amountSection
            notesSection
            photoSection
            updateEntryButton
        }
        .padding(.horizontal, 20)
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.pink)
                    .font(.title2)
                Text("When did baby eat?")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            DatePicker("Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "en_US"))
                .onChange(of: selectedDate) { oldDate, newDate in
                    print("📅 EditEntryView DatePicker changed - Old: \(dateFormatter.string(from: oldDate)) -> New: \(dateFormatter.string(from: newDate))")
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.pink.opacity(0.1))
                )
                .padding(.horizontal, 5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .pink.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
    
    private var foodSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "fork.knife.circle")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("What did baby eat?")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            foodLibraryButton
            customFoodInput
            categorySelection
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .orange.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
    
    private var foodLibraryButton: some View {
        Button(action: {
            showFoodLibrary = true
        }) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.white)
                Text("Browse Food Library")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue.gradient)
            )
            .foregroundColor(.white)
        }
    }
    
    private var customFoodInput: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Or enter custom food:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextField("Enter food name...", text: $foodName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: selectedLibraryItem) { item in
                    if let item = item {
                        foodName = item.name
                        selectedCategory = item.category
                        isFromLibrary = true
                    }
                }
        }
    }
    
    private var categorySelection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Food Category:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Picker("Category", selection: $selectedCategory) {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    HStack {
                        Text(category.icon)
                        Text(category.rawValue)
                    }
                    .tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
    
    private var amountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "scalemass")
                    .foregroundColor(.green)
                    .font(.title2)
                Text("How much did baby eat?")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("0", value: $amount, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Unit:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(AmountUnit.allCases, id: \.self) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .green.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.purple)
                    .font(.title2)
                Text("Additional Notes")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            TextField("Any notes about this meal...", text: $notes, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .purple.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "camera.circle")
                    .foregroundColor(.green)
                    .font(.title2)
                Text("Baby's Photo")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 15) {
                if let photoImageData, let uiImage = UIImage(data: photoImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.pink.opacity(0.3), lineWidth: 2)
                        )
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.green.opacity(0.6))
                        
                        Text("Add a cute photo!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.green.opacity(0.1))
                            .stroke(Color.green.opacity(0.3), lineWidth: 2)
                    )
                }
                
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    HStack {
                        Image(systemName: photoImageData != nil ? "arrow.clockwise" : "camera.fill")
                        Text(photoImageData != nil ? "Change Photo" : "Take Photo")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.green.gradient)
                    )
                    .foregroundColor(.white)
                }
                .onChange(of: selectedPhotoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            photoImageData = data
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .green.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
    
    private var updateEntryButton: some View {
        Button(action: {
            if !foodName.isEmpty {
                let updatedEntry = BabyFoodEntry(
                    id: entry.id,
                    date: selectedDate,
                    foodName: foodName,
                    foodCategory: selectedCategory,
                    amount: amount,
                    amountUnit: selectedUnit,
                    isFromLibrary: isFromLibrary,
                    photoData: photoImageData,
                    notes: notes.isEmpty ? nil : notes
                )
                foodStore.updateEntry(updatedEntry)
                dismiss()
            }
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                Text("Update Entry")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .orange.opacity(0.4), radius: 15, x: 0, y: 8)
            )
            .foregroundColor(.white)
        }
        .disabled(foodName.isEmpty)
        .opacity(foodName.isEmpty ? 0.6 : 1.0)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.orange.opacity(0.05), Color.red.opacity(0.05)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Date Formatter for displaying selected date
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
}

struct EditEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEntry = BabyFoodEntry(
            date: Date(),
            foodName: "Apple Puree",
            foodCategory: .fruits,
            amount: 30.0,
            amountUnit: .grams,
            isFromLibrary: true,
            notes: "Baby loved it!"
        )
        EditEntryView(foodStore: FoodDataStore(), entry: sampleEntry)
    }
} 