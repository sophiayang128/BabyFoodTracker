//
//  AddEntryView.swift
//  BabyFoodTracker
//
//  Created by Sophia Tang on 7/2/25.
//

// This file defines the view for adding new food entries.

import SwiftUI
import PhotosUI
#if canImport(UIKit)
import UIKit
#endif
import AVFoundation

struct AddEntryView: View {
    @ObservedObject var foodStore: FoodDataStore // Receives data store object
    @StateObject private var foodLibrary = FoodLibrary()
    
    @State private var selectedDate: Date = Date()
    @State private var foodName: String = ""
    @State private var selectedCategory: FoodCategory = .other
    @State private var amount: Double = 0.0
    @State private var selectedUnit: AmountUnit = .ounces
    @State private var notes: String = ""
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? // For PhotosPicker
    @State private var photoImageData: Data? // Stores selected photo data
    @State private var showFoodLibrary: Bool = false
    @State private var isFromLibrary: Bool = false
    @State private var selectedLibraryItem: FoodLibraryItem?
    @State private var showCamera: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    mainContentView
                }
                .background(
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                )
            }
            .background(backgroundGradient)
            .navigationBarHidden(true)
            .sheet(isPresented: $showFoodLibrary) {
                FoodLibraryView(foodLibrary: foodLibrary, selectedItem: $selectedLibraryItem)
            }

            .sheet(isPresented: $showCamera) {
                CameraView(photoImageData: $photoImageData)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .font(.system(size: 40))
                .foregroundColor(.pink)
                .padding(.bottom, 5)
            
            Text("Add Food Entry")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Track your baby's food journey! 🍼")
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
            addEntryButton
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

            DatePicker("Date and Time", selection: $selectedDate, in: minDate...maxDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "en_US"))
                // .onChange(of: selectedDate) { oldDate, newDate in
                //     print("📅 DatePicker changed - Old: \(dateFormatter.string(from: oldDate)) -> New: \(dateFormatter.string(from: newDate))")
                // }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.pink.opacity(0.1))
                )
                .padding(.horizontal, 5)
            
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
            
            Menu {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text("\(category.icon) \(category.rawValue)")
                    }
                }
            } label: {
                HStack {
                    Text(selectedCategory.icon)
                        .font(.title3)
                    Text(selectedCategory.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
            }
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
                
                // Photo selection buttons
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        // Camera button
                        Button(action: {
                            showCamera = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Camera")
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
                        
                        // Photo Library button
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Library")
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
                    
                    if photoImageData != nil {
                        Button(action: {
                            photoImageData = nil
                            selectedPhotoItem = nil
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Remove Photo")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.red.gradient)
                            )
                            .foregroundColor(.white)
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
    
    private var addEntryButton: some View {
        Button(action: {
            if !foodName.isEmpty {
                let newEntry = BabyFoodEntry(
                    date: selectedDate,
                    foodName: foodName,
                    foodCategory: selectedCategory,
                    amount: amount,
                    amountUnit: selectedUnit,
                    isFromLibrary: isFromLibrary,
                    photoData: photoImageData,
                    notes: notes.isEmpty ? nil : notes
                )
                foodStore.addEntry(newEntry)
                resetForm()
            }
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                Text("Add Entry")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .pink.opacity(0.4), radius: 15, x: 0, y: 8)
            )
            .foregroundColor(.white)
        }
        .disabled(foodName.isEmpty)
        .opacity(foodName.isEmpty ? 0.6 : 1.0)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.pink.opacity(0.05), Color.purple.opacity(0.05)]),
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
    
    // Computed properties for date range
    private var minDate: Date {
        Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    }
    
    private var maxDate: Date {
        Calendar.current.date(byAdding: .year, value: 100, to: Date())!
    }
    
    private func resetForm() {
        foodName = ""
        selectedCategory = .other
        amount = 0.0
        selectedUnit = .ounces
        notes = ""
        selectedDate = Date()
        photoImageData = nil
        selectedPhotoItem = nil
        isFromLibrary = false
        selectedLibraryItem = nil
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct FoodLibraryView: View {
    @ObservedObject var foodLibrary: FoodLibrary
    @Binding var selectedItem: FoodLibraryItem?
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedAgeRange = "6-8 months"
    
    private let ageRanges = ["6-8 months", "8-10 months", "10-12 months"]
    
    var filteredFoods: [FoodLibraryItem] {
        let ageFiltered = foodLibrary.getFoodsForAge(selectedAgeRange)
        if searchText.isEmpty {
            return ageFiltered
        } else {
            return ageFiltered.filter { 
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter
                VStack(spacing: 15) {
                    TextField("Search foods...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Picker("Age Range", selection: $selectedAgeRange) {
                        ForEach(ageRanges, id: \.self) { range in
                            Text(range).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.1))
                
                // Food list
                List(filteredFoods) { item in
                    FoodLibraryItemRow(item: item) {
                        selectedItem = item
                        dismiss()
                    }
                }
            }
            .navigationTitle("Food Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FoodLibraryItemRow: View {
    let item: FoodLibraryItem
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 15) {
                Text(item.category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    if let nutritionalInfo = item.nutritionalInfo {
                        Text(nutritionalInfo)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView(foodStore: FoodDataStore())
    }
}
