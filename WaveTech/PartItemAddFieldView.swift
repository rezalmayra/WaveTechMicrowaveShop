import SwiftUI
import Combine

@available(iOS 14.0, *)
struct PartItemAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .foregroundColor(Color.accentColor)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 2) {
                    if !text.isEmpty {
                        Text(title)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .transition(.opacity)
                    }

                    if isSecure {
                        SecureField(text.isEmpty ? title : "", text: $text)
                            .keyboardType(keyboardType)
                            .padding(.vertical, 8)
                    } else {
                        TextField(text.isEmpty ? title : "", text: $text)
                            .keyboardType(keyboardType)
                            .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

@available(iOS 14.0, *)
struct PartItemAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .foregroundColor(Color.accentColor)
                .frame(width: 20)

            DatePicker(title, selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.vertical, 4)
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct PartItemAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .foregroundColor(Color.accentColor)
                .frame(width: 20)

            Toggle(title, isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct PartItemAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(title)
                .font(.headline)
        }
        .padding(.top, 10)
        .foregroundColor(.primary)
    }
}

@available(iOS 14.0, *)
struct PartItemAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: MicrowaveDataStore
    
    @State private var partNumber: String = ""
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var subCategory: String = ""
    @State private var manufacturer: String = ""
    @State private var modelCompatibility: String = ""
    @State private var description: String = ""
    @State private var material: String = ""
    @State private var color: String = ""
    @State private var size: String = ""
    @State private var weightGrams: String = ""
    @State private var unitCost: String = ""
    @State private var sellingPrice: String = ""
    @State private var stockQuantity: String = ""
    @State private var reorderThreshold: String = ""
    @State private var reorderQuantity: String = ""
    @State private var supplier: String = ""
    @State private var supplierContact: String = ""
    @State private var locationBin: String = ""
    @State private var storageCondition: String = ""
    @State private var warrantyMonths: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var lastRestocked: Date = Date()
    @State private var barcode: String = ""
    @State private var notes: String = ""
    @State private var serialTracked: Bool = false
    @State private var compatibleModelsString: String = ""
    @State private var partImageName: String = ""
    @State private var qualityGrade: String = ""
    @State private var rating: String = "3"
    @State private var active: Bool = true
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 15) {
                        PartItemAddSectionHeaderView(title: "Core Identification", iconName: "tag.circle.fill")
                        
                        PartItemAddFieldView(title: "Part Number", iconName: "barcode", text: $partNumber)
                        PartItemAddFieldView(title: "Name", iconName: "pencil.circle.fill", text: $name)
                        
                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Category", iconName: "square.grid.2x2.fill", text: $category)
                            PartItemAddFieldView(title: "Sub-Category", iconName: "square.stack.3d.down.right.fill", text: $subCategory)
                        }
                        
                        PartItemAddFieldView(title: "Manufacturer", iconName: "building.2.fill", text: $manufacturer)
                        PartItemAddFieldView(title: "Model Compatibility (Main)", iconName: "bolt.horizontal.fill", text: $modelCompatibility)
                        
                        PartItemAddFieldView(title: "Compatible Models (Comma Sep.)", iconName: "list.bullet.rectangle.fill", text: $compatibleModelsString)
                        PartItemAddFieldView(title: "Description", iconName: "doc.text.fill", text: $description)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    VStack(alignment: .leading, spacing: 15) {
                        PartItemAddSectionHeaderView(title: "Physical & Quality", iconName: "square.stack.3d.up.fill")

                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Material", iconName: "gearshape.fill", text: $material)
                            PartItemAddFieldView(title: "Color", iconName: "paintpalette.fill", text: $color)
                        }
                        
                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Size", iconName: "ruler.fill", text: $size)
                            PartItemAddFieldView(title: "Weight (Grams)", iconName: "scalemass.fill", text: $weightGrams, keyboardType: .numberPad)
                        }
                        
                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Quality Grade", iconName: "star.lefthalf.fill", text: $qualityGrade)
                            PartItemAddFieldView(title: "Rating (1-5)", iconName: "hand.thumbsup.fill", text: $rating, keyboardType: .numberPad)
                        }
                        
                        PartItemAddFieldView(title: "Part Image Name", iconName: "photo", text: $partImageName)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        PartItemAddSectionHeaderView(title: "Inventory & Financials", iconName: "dollarsign.circle.fill")

                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Unit Cost", iconName: "creditcard.fill", text: $unitCost, keyboardType: .decimalPad)
                            PartItemAddFieldView(title: "Selling Price", iconName: "banknote.fill", text: $sellingPrice, keyboardType: .decimalPad)
                        }

                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Stock Quantity", iconName: "number.square.fill", text: $stockQuantity, keyboardType: .numberPad)
                            PartItemAddFieldView(title: "Reorder Threshold", iconName: "arrow.down.to.line.alt", text: $reorderThreshold, keyboardType: .numberPad)
                        }
                        
                        HStack(spacing: 10) {
                            PartItemAddFieldView(title: "Reorder Quantity", iconName: "arrow.up.to.line.alt", text: $reorderQuantity, keyboardType: .numberPad)
                            PartItemAddFieldView(title: "Location Bin", iconName: "mappin.and.ellipse", text: $locationBin)
                        }
                        
                        PartItemAddFieldView(title: "Barcode", iconName: "barcode.viewfinder", text: $barcode)
                        PartItemAddFieldView(title: "Storage Condition", iconName: "thermometer", text: $storageCondition)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    VStack(alignment: .leading, spacing: 15) {
                        PartItemAddSectionHeaderView(title: "Supplier & Warranty", iconName: "shield.lefthalf.filled")

                        PartItemAddFieldView(title: "Supplier", iconName: "person.3.fill", text: $supplier)
                        PartItemAddFieldView(title: "Supplier Contact", iconName: "phone.fill", text: $supplierContact)
                        PartItemAddDatePickerView(title: "Last Restocked", iconName: "arrow.clockwise.circle.fill", date: $lastRestocked)
                        
                        PartItemAddToggleView(title: "Serial Tracked", iconName: "list.number", isOn: $serialTracked)
                        PartItemAddToggleView(title: "Active Status", iconName: "checkmark.circle.fill", isOn: $active)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        PartItemAddSectionHeaderView(title: "General Notes", iconName: "note.text.fill")
                        PartItemAddFieldView(title: "Notes", iconName: "note.text", text: $notes)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    Button(action: {
                        validateAndSave()
                    }) {
                        Text("Add New Part Item")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top, 10)
            }
            .navigationTitle("New Part Inventory")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertTitle.contains("Success") {
                }
            })
        }
    }
    
    func validateAndSave() {
        var errors: [String] = []
        
        if partNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Part Number is required.") }
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Name is required.") }
        if category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Category is required.") }
        if manufacturer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Manufacturer is required.") }
        if modelCompatibility.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Model Compatibility is required.") }
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Description is required.") }
        if Int(weightGrams) == nil { errors.append("Weight (Grams) must be a valid number.") }
        if Double(unitCost) == nil { errors.append("Unit Cost must be a valid number.") }
        if Double(sellingPrice) == nil { errors.append("Selling Price must be a valid number.") }
        if Int(stockQuantity) == nil { errors.append("Stock Quantity must be a valid number.") }
        if Int(reorderThreshold) == nil { errors.append("Reorder Threshold must be a valid number.") }
        if Int(reorderQuantity) == nil { errors.append("Reorder Quantity must be a valid number.") }
        if supplier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Supplier is required.") }
        if locationBin.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Location Bin is required.") }
        if Int(warrantyMonths) == nil { errors.append("Warranty (Months) must be a valid number.") }
        if Int(rating) == nil || (Int(rating) ?? 0 < 1 || Int(rating) ?? 0 > 5) { errors.append("Rating must be a number between 1 and 5.") }
        
        if errors.isEmpty {
            let compatibleModels = compatibleModelsString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
            
            let newPart = PartItem(
                partNumber: partNumber,
                name: name,
                category: category,
                subCategory: subCategory,
                manufacturer: manufacturer,
                modelCompatibility: modelCompatibility,
                description: description,
                material: material,
                color: color,
                size: size,
                weightGrams: Int(weightGrams) ?? 0,
                unitCost: Double(unitCost) ?? 0.0,
                sellingPrice: Double(sellingPrice) ?? 0.0,
                stockQuantity: Int(stockQuantity) ?? 0,
                reorderThreshold: Int(reorderThreshold) ?? 0,
                reorderQuantity: Int(reorderQuantity) ?? 0,
                supplier: supplier,
                supplierContact: supplierContact,
                locationBin: locationBin,
                storageCondition: storageCondition,
                warrantyMonths: Int(warrantyMonths) ?? 0,
                warrantyExpiry: Calendar.current.date(byAdding: .month, value: Int(warrantyMonths) ?? 0, to: purchaseDate),
                purchaseDate: purchaseDate,
                lastRestocked: lastRestocked,
                barcode: barcode,
                notes: notes,
                serialTracked: serialTracked,
                compatibleModels: compatibleModels,
                partImageName: partImageName,
                qualityGrade: qualityGrade,
                rating: Int(rating) ?? 3,
                active: active,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            dataStore.addPart(newPart)
            alertTitle = "Success!"
            alertMessage = "The part '\(name)' was added successfully to the inventory."
            showAlert = true
            
        } else {
            alertTitle = "Validation Failed"
            alertMessage = "Please correct the following errors:\n\n• " + errors.joined(separator: "\n• ")
            showAlert = true
        }
    }
}

@available(iOS 14.0, *)
struct PartItemSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search parts by name or number...", text: $searchText)
                .padding(8)
                .padding(.horizontal, isEditing ? 30 : 25)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.isEditing = true
                    }
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing && !searchText.isEmpty {
                            Button(action: {
                                withAnimation {
                                    self.searchText = ""
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(.accentColor)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct PartItemCompactFieldView: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 14.0, *)
struct PartItemPillView: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.white)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color.accentColor.opacity(0.9))
        .cornerRadius(10)
    }
}


@available(iOS 14.0, *)
struct PartItemCardRowView: View {
    let part: PartItem
    
    private func currency(_ value: Double) -> String {
        String(format: "$%.2f", value)
    }
    
    private func stockColor(_ stock: Int, _ threshold: Int) -> Color {
        if stock == 0 { return .red }
        if stock <= threshold { return .orange }
        return .green
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // Header Section
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "barcode.fill").font(.caption)
                        Text(part.partNumber)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: part.active ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(part.active ? .green : .red)
                    .font(.title2)
            }
            .padding([.horizontal, .top])
            
            Divider().padding(.horizontal)
            
            // Core Details Section
            VStack(spacing: 8) {
                HStack {
                    PartItemCompactFieldView(label: "Unit Cost", value: currency(part.unitCost), icon: "creditcard.fill", color: .blue)
                    PartItemCompactFieldView(label: "Selling Price", value: currency(part.sellingPrice), icon: "banknote.fill", color: .purple)
                }
                
                HStack {
                    PartItemCompactFieldView(label: "In Stock", value: "\(part.stockQuantity)", icon: "shippingbox.fill", color: stockColor(part.stockQuantity, part.reorderThreshold))
                    PartItemCompactFieldView(label: "Reorder @", value: "\(part.reorderThreshold)", icon: "arrow.triangle.2.circlepath", color: .gray)
                }
                
                HStack {
                    PartItemCompactFieldView(label: "Manufacturer", value: part.manufacturer, icon: "building.2.fill", color: .green)
                    PartItemCompactFieldView(label: "Supplier", value: part.supplier, icon: "person.crop.rectangle", color: .orange)
                }
                
                HStack {
                    PartItemCompactFieldView(label: "Supplier Contact", value: part.supplierContact, icon: "phone.fill", color: .blue)
                    PartItemCompactFieldView(label: "Location", value: part.locationBin, icon: "mappin.and.ellipse", color: .red)
                }
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            Divider().padding(.horizontal)
            
            // Extended Horizontal Scroll Section
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    PartItemPillView(title: "Category", value: part.category, icon: "square.grid.2x2")
                    PartItemPillView(title: "Subcategory", value: part.subCategory, icon: "square.grid.3x3")
                    PartItemPillView(title: "Material", value: part.material, icon: "gearshape.fill")
                    PartItemPillView(title: "Color", value: part.color, icon: "paintpalette.fill")
                    PartItemPillView(title: "Size", value: part.size, icon: "ruler")
                    PartItemPillView(title: "Weight (g)", value: "\(part.weightGrams)", icon: "scalemass.fill")
                    PartItemPillView(title: "Warranty (mo)", value: "\(part.warrantyMonths)", icon: "clock.arrow.circlepath")
                    PartItemPillView(title: "Grade", value: part.qualityGrade, icon: "star.fill")
                    PartItemPillView(title: "Rating", value: "\(part.rating)/5", icon: "hand.thumbsup.fill")
                    PartItemPillView(title: "Model", value: part.modelCompatibility, icon: "bolt.fill")
                    PartItemPillView(title: "Tracked", value: part.serialTracked ? "Yes" : "No", icon: "number.square")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Color(.systemGray6))
            
            Divider().padding(.horizontal)
            
            // Meta Information Section
            VStack(spacing: 8) {
                HStack {
                    PartItemCompactFieldView(label: "Purchase Date", value: formatDate(part.purchaseDate), icon: "calendar.badge.plus", color: .blue)
                    PartItemCompactFieldView(label: "Last Restocked", value: formatDate(part.lastRestocked), icon: "arrow.clockwise.circle", color: .green)
                }
                
                HStack {
                    PartItemCompactFieldView(label: "Warranty Expiry", value: formatDate(part.warrantyExpiry), icon: "calendar.badge.clock", color: .red)
                    PartItemCompactFieldView(label: "Updated", value: formatDate(part.updatedAt), icon: "clock.fill", color: .gray)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Divider().padding(.horizontal)
            
            // Description & Notes Section
            VStack(alignment: .leading, spacing: 6) {
                Text("Description")
                    .font(.headline)
                Text(part.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Notes")
                    .font(.headline)
                Text(part.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        .padding([.horizontal, .bottom], 8)
    }
}

@available(iOS 14.0, *)
struct PartItemNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "tray.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .opacity(0.5)
            
            Text("No Part Items Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("Looks like your inventory is empty or the search returned no results. Tap '+' to add a new part.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct PartItemListView: View {
    @ObservedObject var dataStore: MicrowaveDataStore
    @State private var searchText: String = ""
    @State private var showAddView: Bool = false
    
    var filteredParts: [PartItem] {
        if searchText.isEmpty {
            return dataStore.parts
        } else {
            return dataStore.parts.filter { part in
                part.name.localizedCaseInsensitiveContains(searchText) ||
                part.partNumber.localizedCaseInsensitiveContains(searchText) ||
                part.manufacturer.localizedCaseInsensitiveContains(searchText) ||
                part.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                
                PartItemSearchBarView(searchText: $searchText)
                    .padding(.vertical, 10)
                
                if filteredParts.isEmpty {
                    PartItemNoDataView()
                } else {
                    List {
                        ForEach(filteredParts) { part in
                            NavigationLink(destination: PartItemDetailView(part: part)) {
                                PartItemCardRowView(part: part)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color.clear)
                                    .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deletePart)
                        .listRowBackground(Color(.systemGray6))
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Part Inventory (\(filteredParts.count))")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            )
            .sheet(isPresented: $showAddView) {
                NavigationView {
                    PartItemAddView(dataStore : dataStore)
                }
            }
        
    }
    
    func deletePart(at offsets: IndexSet) {
        let partsToDelete = offsets.map { self.filteredParts[$0] }
        
        for part in partsToDelete {
            if let index = dataStore.parts.firstIndex(where: { $0.id == part.id }) {
                dataStore.parts.remove(at: index)
            }
        }
    }
}

@available(iOS 14.0, *)
struct PartItemDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 20)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
            }

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 6)
    }
}

@available(iOS 14.0, *)
struct PartItemDetailBlock<Content: View>: View {
    let title: String
    let iconName: String
    let content: Content

    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)

            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct PartItemDetailView: View {
    let part: PartItem
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private func currency(_ value: Double) -> String {
        String(format: "$%.2f", value)
    }
    
    private func boolDisplay(_ value: Bool) -> String {
        value ? "Yes" : "No"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                VStack {
                    Image(systemName: part.serialTracked ? "figure.box.truck" : "cube.box.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .padding(.top)

                    Text(part.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)

                    Text(part.partNumber)
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.8))
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                
                PartItemDetailBlock(title: "Part Specifications", iconName: "gearshape.2.fill") {
                    VStack(alignment: .leading, spacing: 5) {
                        PartItemDetailFieldRow(label: "Category", value: part.category, icon: "square.grid.2x2", color: .blue)
                        PartItemDetailFieldRow(label: "Sub-Category", value: part.subCategory, icon: "square.stack.3d.down.right", color: .blue)
                        PartItemDetailFieldRow(label: "Manufacturer", value: part.manufacturer, icon: "building.2", color: .blue)
                        PartItemDetailFieldRow(label: "Model Comp.", value: part.modelCompatibility, icon: "bolt.horizontal.fill", color: .blue)
                        PartItemDetailFieldRow(label: "Compatible Models", value: part.compatibleModels.joined(separator: ", "), icon: "list.bullet.rectangle.fill", color: .blue)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        PartItemDetailFieldRow(label: "Material", value: part.material, icon: "gearshape.fill", color: .orange)
                        PartItemDetailFieldRow(label: "Color", value: part.color, icon: "paintpalette.fill", color: .orange)
                        PartItemDetailFieldRow(label: "Size", value: part.size, icon: "ruler.fill", color: .orange)
                        PartItemDetailFieldRow(label: "Weight (g)", value: "\(part.weightGrams)", icon: "scalemass", color: .orange)
                        PartItemDetailFieldRow(label: "Quality Grade", value: part.qualityGrade, icon: "star.lefthalf.fill", color: .orange)
                        PartItemDetailFieldRow(label: "Rating", value: "\(part.rating)/5", icon: "hand.thumbsup.fill", color: .orange)
                        PartItemDetailFieldRow(label: "Image Name", value: part.partImageName, icon: "photo", color: .orange)
                    }
                    
                    Divider()
                    
                    PartItemDetailBlock(title: "Description", iconName: "doc.text.fill") {
                        Text(part.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
                .offset(y: -20)
                
                PartItemDetailBlock(title: "Inventory & Cost", iconName: "banknote.fill") {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            PartItemDetailFieldRow(label: "Unit Cost", value: currency(part.unitCost), icon: "creditcard.fill", color: .purple)
                            PartItemDetailFieldRow(label: "Selling Price", value: currency(part.sellingPrice), icon: "tag.fill", color: .purple)
                            PartItemDetailFieldRow(label: "Location Bin", value: part.locationBin, icon: "mappin.and.ellipse", color: .purple)
                            PartItemDetailFieldRow(label: "Storage Cond.", value: part.storageCondition, icon: "thermometer", color: .purple)
                        }
                        
                        Divider().padding(.horizontal, 5)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            PartItemDetailFieldRow(label: "Stock Quantity", value: "\(part.stockQuantity)", icon: "number.square.fill", color: .green)
                            PartItemDetailFieldRow(label: "Reorder Threshold", value: "\(part.reorderThreshold)", icon: "arrow.down.to.line.alt", color: .red)
                            PartItemDetailFieldRow(label: "Reorder Quantity", value: "\(part.reorderQuantity)", icon: "arrow.up.to.line.alt", color: .green)
                            PartItemDetailFieldRow(label: "Barcode", value: part.barcode, icon: "barcode", color: .green)
                            PartItemDetailFieldRow(label: "Serial Tracked", value: boolDisplay(part.serialTracked), icon: "list.number", color: .green)
                            PartItemDetailFieldRow(label: "Active", value: boolDisplay(part.active), icon: "checkmark.circle", color: .green)
                        }
                    }
                }
                .padding(.horizontal)
                
                PartItemDetailBlock(title: "Supplier, Warranty & Dates", iconName: "calendar.badge.clock.fill") {
                    PartItemDetailFieldRow(label: "Supplier", value: part.supplier, icon: "person.3.fill", color: .yellow)
                    PartItemDetailFieldRow(label: "Supplier Contact", value: part.supplierContact, icon: "phone.fill", color: .yellow)
                    
                    Divider()
                    
                    PartItemDetailFieldRow(label: "Purchase Date", value: dateFormatter.string(from: part.purchaseDate), icon: "calendar", color: .green)
                    PartItemDetailFieldRow(label: "Last Restocked", value: dateFormatter.string(from: part.lastRestocked), icon: "arrow.clockwise", color: .yellow)
                    PartItemDetailFieldRow(label: "Warranty (Months)", value: "\(part.warrantyMonths)", icon: "checkmark.shield.fill", color: .red)
                    PartItemDetailFieldRow(label: "Warranty Expiry", value: part.warrantyExpiry != nil ? dateFormatter.string(from: part.warrantyExpiry!) : "N/A", icon: "xmark.shield.fill", color: .blue)
                    
                    Divider()
                    
                    PartItemDetailFieldRow(label: "Created At", value: dateFormatter.string(from: part.createdAt), icon: "plus.square.on.square", color: .gray)
                    PartItemDetailFieldRow(label: "Updated At", value: dateFormatter.string(from: part.updatedAt), icon: "square.and.pencil", color: .gray)
                }
                .padding(.horizontal)
                
                PartItemDetailBlock(title: "Notes", iconName: "note.text.fill") {
                    Text(part.notes)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)

            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationTitle("Part Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

