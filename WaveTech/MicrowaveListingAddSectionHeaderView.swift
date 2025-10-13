import SwiftUI
import Combine

@available(iOS 14.0, *)
extension Color {
    static let accentBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let backgroundGray = Color(.systemGray6)
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let successGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let errorRed = Color(red: 0.8, green: 0.3, blue: 0.3)
}

@available(iOS 14.0, *)
extension DateFormatter {
    static let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let customDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

@available(iOS 14.0, *)
struct MicrowaveListingAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentBlue)
                .font(.headline)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal)
    }
}
@available(iOS 14.0, *)
struct MicrowaveListingAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var isRequired: Bool = true
    var keyboardType: UIKeyboardType = .default

    var isFloating: Bool {
        !text.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Floating title
            Text(title + (isRequired ? "*" : ""))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isFloating ? .blue : .gray)
                .padding(.leading, 8)
                .offset(y: -4)
                .animation(.easeInOut(duration: 0.2), value: isFloating)

            // Text field with icon
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 18)
                TextField("Enter \(title.lowercased())", text: $text)
                    .foregroundColor(.primary)
                    .font(.body)
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(text.isEmpty ? Color(.systemGray4) : .blue, lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// MARK: - Integer Field View
@available(iOS 14.0, *)
struct MicrowaveListingAddIntFieldView: View {
    let title: String
    let iconName: String
    @Binding var value: Int
    var isRequired: Bool = true

    @State private var text: String = ""

    var body: some View {
        MicrowaveListingAddFieldView(
            title: title,
            iconName: iconName,
            text: $text,
            isRequired: isRequired,
            keyboardType: .numberPad
        )
        .onAppear {
            text = value == 0 ? "" : String(value)
        }
        .onChange(of: text) { newValue in
            value = Int(newValue) ?? 0
        }
    }
}

@available(iOS 14.0, *)
struct MicrowaveListingAddDoubleFieldView: View {
    let title: String
    let iconName: String
    @Binding var value: Double
    var isRequired: Bool = true

    @State private var text: String = ""

    var body: some View {
        MicrowaveListingAddFieldView(
            title: title,
            iconName: iconName,
            text: $text,
            isRequired: isRequired,
            keyboardType: .decimalPad
        )
        .onAppear {
            text = value == 0.0 ? "" : String(value)
        }
        .onChange(of: text) { newValue in
            value = Double(newValue) ?? 0.0
        }
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    var showTime: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title + "*")
                .font(.caption)
                .foregroundColor(.accentBlue)
                .padding(.leading)

            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondaryText)
                    .padding(.leading)
                
                if showTime {
                    DatePicker(title, selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                } else {
                    DatePicker(title, selection: $date, displayedComponents: .date)
                        .labelsHidden()
                }
                Spacer()
            }
            .padding(.bottom, 5)

            Divider()
                .background(Color(.systemGray4))
                .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct MicrowaveListingAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: MicrowaveDataStore

    @State private var sku: String = ""
    @State private var modelName: String = ""
    @State private var serialNumber: String = ""
    @State private var category: String = ""
    @State private var brand: String = ""
    @State private var wattage: Int = 0
    @State private var voltage: Int = 0
    @State private var capacityLiters: Int = 0
    @State private var color: String = ""
    @State private var dimensions: String = ""
    @State private var weightKg: Double = 0.0
    @State private var material: String = ""
    @State private var controlType: String = ""
    @State private var features: String = ""
    @State private var energyRating: String = ""
    @State private var warrantyYears: Int = 0
    @State private var manufactureDate: Date = Date()
    @State private var purchaseDate: Date = Date()
    @State private var supplier: String = ""
    @State private var costPrice: Double = 0.0
    @State private var sellingPrice: Double = 0.0
    @State private var stockQuantity: Int = 1
    @State private var locationBin: String = ""
    @State private var condition: String = ""
    @State private var notes: String = ""
    @State private var powerConsumption: Double = 0.0
    @State private var countryOfOrigin: String = ""
    @State private var barcode: String = ""
    @State private var maintenanceIntervalDays: Int = 0
    @State private var lastServicedDate: Date? = nil
    @State private var nextServiceDate: Date? = nil
    @State private var favorite: Bool = false
    @State private var tags: String = ""

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private var allRequiredFields: [String: Any] {
        [
            "SKU": sku, "Model Name": modelName, "Serial Number": serialNumber, "Category": category,
            "Brand": brand, "Wattage": wattage, "Voltage": voltage, "Capacity (L)": capacityLiters,
            "Color": color, "Dimensions": dimensions, "Weight (Kg)": weightKg, "Material": material,
            "Control Type": controlType, "Energy Rating": energyRating, "Warranty (Years)": warrantyYears,
            "Supplier": supplier, "Cost Price": costPrice, "Selling Price": sellingPrice,
            "Stock Quantity": stockQuantity, "Location Bin": locationBin, "Country of Origin": countryOfOrigin,
            "Barcode": barcode, "Maintenance Interval": maintenanceIntervalDays
        ]
    }

    private func validateAndSave() {
        var errors: [String] = []
        var featureArray: [String] = []
        var tagArray: [String] = []

        for (name, value) in allRequiredFields {
            if let stringValue = value as? String, stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.append("\(name) is required.")
            }
        }

        if wattage <= 0 { errors.append("Wattage must be > 0.") }
        if voltage <= 0 { errors.append("Voltage must be > 0.") }
        if capacityLiters <= 0 { errors.append("Capacity must be > 0.") }
        if warrantyYears < 0 { errors.append("Warranty must be >= 0.") }
        if sellingPrice <= 0.0 { errors.append("Selling Price must be > 0.0.") }
        if costPrice <= 0.0 { errors.append("Cost Price must be > 0.0.") }
        if stockQuantity < 0 { errors.append("Stock Quantity must be >= 0.") }
        if maintenanceIntervalDays < 0 { errors.append("Maintenance Interval must be >= 0.") }

        if !features.isEmpty { featureArray = features.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } }
        if !tags.isEmpty { tagArray = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } }


        if errors.isEmpty {
            let newListing = MicrowaveListing(
                sku: sku, modelName: modelName, serialNumber: serialNumber, category: category,
                brand: brand, wattage: wattage, voltage: voltage, capacityLiters: capacityLiters,
                color: color, dimensions: dimensions, weightKg: weightKg, material: material,
                controlType: controlType, features: featureArray, energyRating: energyRating,
                warrantyYears: warrantyYears, manufactureDate: manufactureDate, purchaseDate: purchaseDate,
                supplier: supplier, costPrice: costPrice, sellingPrice: sellingPrice,
                stockQuantity: stockQuantity, locationBin: locationBin, condition: condition,
                notes: notes, powerConsumption: powerConsumption, countryOfOrigin: countryOfOrigin,
                barcode: barcode, maintenanceIntervalDays: maintenanceIntervalDays,
                lastServicedDate: lastServicedDate, nextServiceDate: nextServiceDate, favorite: favorite,
                tags: tagArray, createdAt: Date(), updatedAt: Date()
            )

            dataStore.addMicrowave(newListing)
            alertTitle = "Success!"
            alertMessage = "The Microwave Listing for **\(modelName)** has been added to the inventory."
            showingAlert = true

        } else {
            alertTitle = "Validation Failed (\(errors.count) Errors)"
            alertMessage = "- " + errors.joined(separator: "\n- ")
            showingAlert = true
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    MicrowaveListingAddSectionHeaderView(title: "Core Product Details", iconName: "tag.circle.fill")
                    
                    VStack {
                        HStack {
                            MicrowaveListingAddFieldView(title: "SKU", iconName: "barcode", text: $sku)
                            MicrowaveListingAddFieldView(title: "Brand", iconName: "globe", text: $brand)
                        }
                        .padding(.horizontal, -8)

                        MicrowaveListingAddFieldView(title: "Model Name", iconName: "microwaves", text: $modelName)
                        MicrowaveListingAddFieldView(title: "Serial Number", iconName: "number.square", text: $serialNumber)
                        MicrowaveListingAddFieldView(title: "Barcode", iconName: "qrcode", text: $barcode)
                    }
                    .padding(.horizontal, 8)
                    .background(Color.backgroundGray.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    MicrowaveListingAddSectionHeaderView(title: "Specifications & Material", iconName: "gearshape.2.fill")

                    HStack {
                        MicrowaveListingAddFieldView(title: "Category", iconName: "folder", text: $category)
                        MicrowaveListingAddFieldView(title: "Control Type", iconName: "dial.max.fill", text: $controlType)
                    }
                    .padding(.horizontal)

                    HStack {
                        MicrowaveListingAddIntFieldView(title: "Wattage (W)", iconName: "bolt.fill", value: $wattage)
                        MicrowaveListingAddIntFieldView(title: "Voltage (V)", iconName: "antenna.radiowaves.left.and.right", value: $voltage)
                    }
                    .padding(.horizontal)

                    HStack {
                        MicrowaveListingAddIntFieldView(title: "Capacity (L)", iconName: "cube.fill", value: $capacityLiters)
                        MicrowaveListingAddDoubleFieldView(title: "Weight (Kg)", iconName: "scale.3d", value: $weightKg)
                    }
                    .padding(.horizontal)

                    HStack {
                        MicrowaveListingAddFieldView(title: "Color", iconName: "paintpalette.fill", text: $color)
                        MicrowaveListingAddFieldView(title: "Material", iconName: "tongs", text: $material)
                    }
                    .padding(.horizontal)
                    
                    MicrowaveListingAddFieldView(title: "Dimensions (e.g. 45x35x25 cm)", iconName: "ruler.fill", text: $dimensions)
                        .padding(.horizontal)

                    MicrowaveListingAddSectionHeaderView(title: "Financial & Inventory", iconName: "dollarsign.circle.fill")


                    HStack {
                        MicrowaveListingAddIntFieldView(title: "Stock Quantity", iconName: "building.columns.fill", value: $stockQuantity)
                        MicrowaveListingAddFieldView(title: "Location Bin", iconName: "mappin.and.ellipse", text: $locationBin)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        MicrowaveListingAddFieldView(title: "Energy Rating", iconName: "leaf.fill", text: $energyRating)
                        MicrowaveListingAddDoubleFieldView(title: "Power Consumption (kW/h)", iconName: "wave.3.left", value: $powerConsumption)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        MicrowaveListingAddIntFieldView(title: "Warranty (Years)", iconName: "hand.raised.fill", value: $warrantyYears)
                        MicrowaveListingAddFieldView(title: "Supplier", iconName: "truck.box.fill", text: $supplier)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        MicrowaveListingAddFieldView(title: "Country of Origin", iconName: "flag.circle.fill", text: $countryOfOrigin)
                        MicrowaveListingAddFieldView(title: "Condition", iconName: "heart.text.square.fill", text: $condition)
                    }
                    .padding(.horizontal)

                    MicrowaveListingAddSectionHeaderView(title: "Maintenance & Details", iconName: "wrench.and.screwdriver.fill")
                    
                    MicrowaveListingAddIntFieldView(title: "Maintenance Interval (Days)", iconName: "timer", value: $maintenanceIntervalDays)
                        .padding(.horizontal)
                    
                    MicrowaveListingAddFieldView(title: "Features (Comma Separated)", iconName: "list.bullet.clipboard.fill", text: $features, isRequired: false)
                        .padding(.horizontal)
                    
                    MicrowaveListingAddFieldView(title: "Tags (Comma Separated)", iconName: "number", text: $tags, isRequired: false)
                        .padding(.horizontal)
                    
                    MicrowaveListingAddFieldView(title: "Notes", iconName: "note.text", text: $notes, isRequired: false)
                        .padding(.horizontal)
                    
                    Toggle(isOn: $favorite) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Favorite Listing")
                        }
                    }
                    .padding()
                    .background(Color.backgroundGray.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    MicrowaveListingAddSectionHeaderView(title: "Timeline", iconName: "calendar.badge.clock")

                    HStack {
                        MicrowaveListingAddDatePickerView(title: "Manufacture Date", iconName: "hammer.fill", date: $manufactureDate)
                        MicrowaveListingAddDatePickerView(title: "Purchase Date", iconName: "creditcard.fill", date: $purchaseDate)
                    }
                    .padding(.horizontal, -8)

                    Button(action: validateAndSave) {
                        Text("Add New Microwave Listing")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentBlue)
                            .cornerRadius(12)
                            .shadow(color: Color.accentBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                    .padding(.top, 20)
                }
            }
            .background(Color.backgroundGray.ignoresSafeArea())
            .navigationTitle("New Microwave")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
            .alert(isPresented: $showingAlert) {
                if alertTitle.contains("Success") {
                    return Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                } else {
                    return Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondaryText.opacity(0.5))
            
            Text("No Microwaves Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Looks like the inventory is empty or your search is too specific. Try adding a new listing!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondaryText)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 50)
        .background(Color.backgroundGray.opacity(0.7))
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(isEditing ? .accentBlue : .secondaryText)
                    .padding(.leading, 8)

                TextField("Search listings...", text: $searchText)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            self.isEditing = true
                        }
                    }
                    .padding(.vertical, 8)
                    .foregroundColor(.primaryText)
            }
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.leading, isEditing ? 10 : 15)
            .animation(.easeInOut, value: isEditing)

            if isEditing {
                Button("Cancel") {
                    self.searchText = ""
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.isEditing = false
                    }
                    UIApplication.shared.endEditing()
                }
                .padding(.trailing, 15)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.vertical, 8)
        .background(Color.backgroundGray)
    }
}

@available(iOS 14.0, *)
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingListRowView: View {
    let listing: MicrowaveListing

    private var stockColor: Color {
        if listing.stockQuantity > 5 {
            return .successGreen
        } else if listing.stockQuantity > 0 {
            return .orange
        } else {
            return .errorRed
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: listing.favorite ? "star.fill" : "microwaves.fill")
                    .foregroundColor(listing.favorite ? .yellow : .accentBlue)
                    .font(.title2)

                VStack(alignment: .leading) {
                    Text(listing.modelName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                    Text("\(listing.brand) (\(listing.sku))")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(listing.stockQuantity) in Stock")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(stockColor)
                        .cornerRadius(6)
                    
                    Text(listing.locationBin)
                        .font(.caption2)
                        .foregroundColor(.secondaryText)
                }
            }
            .padding([.top, .horizontal], 15)

            Divider().padding(.horizontal, 15)

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    MicrowaveListingListDetailItem(icon: "bolt.fill", title: "Power", value: "\(listing.wattage)W / \(listing.voltage)V")
                    MicrowaveListingListDetailItem(icon: "cube.box", title: "Capacity", value: "\(listing.capacityLiters)L")
                    MicrowaveListingListDetailItem(icon: "paintpalette", title: "Color", value: listing.color)
                    MicrowaveListingListDetailItem(icon: "leaf.fill", title: "Energy", value: listing.energyRating)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    MicrowaveListingListDetailItem(icon: "key", title: "Control", value: listing.controlType)
                    MicrowaveListingListDetailItem(icon: "tongs", title: "Material", value: listing.material)
                    MicrowaveListingListDetailItem(icon: "ruler.fill", title: "Size", value: listing.dimensions)
                    MicrowaveListingListDetailItem(icon: "dollarsign.circle", title: "Price", value: "$\(String(format: "%.2f", listing.sellingPrice))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 15)
            
            HStack(spacing: 15) {
                MicrowaveListingListDateItem(icon: "calendar", title: "Mfr Date", date: listing.manufactureDate)
                MicrowaveListingListDateItem(icon: "calendar.badge.checkmark", title: "Purchased", date: listing.purchaseDate)
                MicrowaveListingListDateItem(icon: "lock.shield", title: "Warranty", value: "\(listing.warrantyYears) Yrs")
                MicrowaveListingListDateItem(icon: "wrench.and.screwdriver", title: "Next Service", date: listing.nextServiceDate, value: listing.nextServiceDate == nil ? "N/A" : nil)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.backgroundGray.opacity(0.4))
            
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct MicrowaveListingListDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.accentBlue)
                .frame(width: 15)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondaryText)
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primaryText)
            }
        }
    }
}

@available(iOS 14.0, *)
struct MicrowaveListingListDateItem: View {
    let icon: String
    let title: String
    var date: Date?
    var value: String?

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondaryText)
            
            if let date = date {
                Text(DateFormatter.customDateFormatter.string(from: date))
                    .font(.caption2)
                    .foregroundColor(.primaryText)
            } else if let value = value {
                Text(value)
                    .font(.caption2)
                    .foregroundColor(.primaryText)
            }
        }
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingListView: View {
    @ObservedObject var dataStore: MicrowaveDataStore
    @State private var showingAddView = false
    @State private var searchText = ""

    var filteredMicrowaves: [MicrowaveListing] {
        if searchText.isEmpty {
            return dataStore.microwaves
        } else {
            return dataStore.microwaves.filter {
                $0.modelName.localizedCaseInsensitiveContains(searchText) ||
                $0.brand.localizedCaseInsensitiveContains(searchText) ||
                $0.sku.localizedCaseInsensitiveContains(searchText) ||
                $0.serialNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
            VStack(spacing: 0) {
                MicrowaveListingSearchBarView(searchText: $searchText)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                
                if filteredMicrowaves.isEmpty {
                    MicrowaveListingNoDataView()
                } else {
                    List {
                        ForEach(filteredMicrowaves) { listing in
                            NavigationLink(destination: MicrowaveListingDetailView(listing: listing)) {
                                MicrowaveListingListRowView(listing: listing)
                                    .padding(.vertical, -8)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color.backgroundGray)
                            }
                        }
                        .onDelete(perform: deleteMicrowave)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.backgroundGray)
                }
            }
            .navigationTitle("Microwave Inventory")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentBlue)
                }
            )
            .sheet(isPresented: $showingAddView) {
                MicrowaveListingAddView(dataStore : dataStore)
            }
        
    }

    private func deleteMicrowave(at offsets: IndexSet) {
        let indicesToDelete = offsets.map { filteredMicrowaves[$0] }
        for item in indicesToDelete {
            if let index = dataStore.microwaves.firstIndex(where: { $0.id == item.id }) {
                dataStore.microwaves.remove(at: index)
            }
        }
        dataStore.deleteMicrowave(at: offsets)
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingDetailFieldRow: View {
    let iconName: String
    let title: String
    let value: String
    let color: Color = .primaryText
    let accentColor: Color = .accentBlue

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: iconName)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 20)
                .foregroundColor(accentColor)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryText)
                Text(value)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(color)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
struct MicrowaveListingDetailSectionBlock<Content: View>: View {
    let title: String
    let iconName: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentBlue)
                    .font(.headline)
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                Spacer()
            }
            .padding(.bottom, 5)
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


@available(iOS 14.0, *)
struct MicrowaveListingDetailView: View {
    let listing: MicrowaveListing

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(spacing: 10) {
                    Image(systemName: listing.favorite ? "star.fill" : "microwaves.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(listing.favorite ? .yellow : .accentBlue)
                        .padding(.top)

                    Text(listing.modelName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primaryText)

                    Text("\(listing.brand) • \(listing.category) • \(listing.sku)")
                        .font(.headline)
                        .foregroundColor(.secondaryText)

                    HStack(spacing: 20) {
                        DetailBadge(icon: "bolt.fill", text: "\(listing.wattage)W")
                        DetailBadge(icon: "cube.fill", text: "\(listing.capacityLiters)L")
                        DetailBadge(icon: "dollarsign.circle.fill", text: "$\(String(format: "%.2f", listing.sellingPrice))")
                    }
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(Color.accentBlue.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)


                MicrowaveListingDetailSectionBlock(title: "Identification & Inventory", iconName: "number.square.fill") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "barcode", title: "SKU", value: listing.sku)
                            MicrowaveListingDetailFieldRow(iconName: "number.circle.fill", title: "Serial Number", value: listing.serialNumber)
                        }
                        
                        Divider()

                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "building.columns.fill", title: "Stock Quantity", value: "\(listing.stockQuantity)")
                            MicrowaveListingDetailFieldRow(iconName: "mappin.and.ellipse", title: "Location Bin", value: listing.locationBin)
                        }
                        
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "tag.circle.fill", title: "Condition", value: listing.condition)
                            MicrowaveListingDetailFieldRow(iconName: "qrcode", title: "Barcode", value: listing.barcode)
                        }
                    }
                }
                .padding(.horizontal)


                MicrowaveListingDetailSectionBlock(title: "Technical Specifications", iconName: "gear.circle.fill") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "antenna.radiowaves.left.and.right", title: "Voltage", value: "\(listing.voltage)V")
                            MicrowaveListingDetailFieldRow(iconName: "scale.3d", title: "Weight", value: "\(String(format: "%.1f", listing.weightKg))kg")
                        }

                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "ruler.fill", title: "Dimensions", value: listing.dimensions)
                            MicrowaveListingDetailFieldRow(iconName: "dial.max.fill", title: "Control Type", value: listing.controlType)
                        }

                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "tongs", title: "Material", value: listing.material)
                            MicrowaveListingDetailFieldRow(iconName: "leaf.fill", title: "Energy Rating", value: listing.energyRating)
                        }
                        
                        MicrowaveListingDetailFieldRow(iconName: "wave.3.left", title: "Power Consumption", value: "\(String(format: "%.2f", listing.powerConsumption)) kW/h")
                        
                        MicrowaveListingDetailFieldRow(iconName: "hand.point.right.fill", title: "Features", value: listing.features.isEmpty ? "N/A" : listing.features.joined(separator: ", "))
                    }
                }
                .padding(.horizontal)

                MicrowaveListingDetailSectionBlock(title: "Financial & Timeline", iconName: "chart.bar.fill") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "arrow.down.to.line.alt", title: "Cost Price", value: "$\(String(format: "%.2f", listing.costPrice))")
                            MicrowaveListingDetailFieldRow(iconName: "arrow.up.to.line.alt", title: "Selling Price", value: "$\(String(format: "%.2f", listing.sellingPrice))")
                        }
                        
                        Divider()
                        
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "hammer.fill", title: "Manufacture Date", value: DateFormatter.customDateFormatter.string(from: listing.manufactureDate))
                            MicrowaveListingDetailFieldRow(iconName: "creditcard.fill", title: "Purchase Date", value: DateFormatter.customDateFormatter.string(from: listing.purchaseDate))
                        }
                        
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "lock.shield.fill", title: "Warranty", value: "\(listing.warrantyYears) Years")
                            MicrowaveListingDetailFieldRow(iconName: "building.2.fill", title: "Supplier", value: listing.supplier)
                        }
                    }
                }
                .padding(.horizontal)

                MicrowaveListingDetailSectionBlock(title: "Maintenance Record", iconName: "wrench.and.screwdriver.fill") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            MicrowaveListingDetailFieldRow(iconName: "timer", title: "Interval", value: "\(listing.maintenanceIntervalDays) Days")
                            MicrowaveListingDetailFieldRow(iconName: "calendar.badge.clock", title: "Last Serviced", value: listing.lastServicedDate != nil ? DateFormatter.customDateFormatter.string(from: listing.lastServicedDate!) : "N/A")
                        }
                        
                        MicrowaveListingDetailFieldRow(iconName: "calendar.badge.plus", title: "Next Service Due", value: listing.nextServiceDate != nil ? DateFormatter.customDateFormatter.string(from: listing.nextServiceDate!) : "N/A")
                    }
                }
                .padding(.horizontal)
                
                MicrowaveListingDetailSectionBlock(title: "Notes & Tags", iconName: "note.text") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(listing.notes.isEmpty ? "No general notes available." : listing.notes)
                            .font(.body)
                            .foregroundColor(.secondaryText)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "number")
                                .foregroundColor(.accentBlue)
                            Text("Tags:")
                                .fontWeight(.medium)
                            Text(listing.tags.isEmpty ? "None" : listing.tags.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
        }
        .background(Color.backgroundGray.ignoresSafeArea(.all, edges: .all))
        .navigationTitle("Listing Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 14.0, *)
struct DetailBadge: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(.systemBackground).opacity(0.8))
        .cornerRadius(8)
    }
}

