
import SwiftUI
import Combine

extension Color {
    static let primaryBackground = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let lightGray = Color(white: 0.9)
    static let darkText = Color(white: 0.2)
    static let dangerRed = Color(red: 0.8, green: 0.2, blue: 0.2)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    static let fullDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

@available(iOS 14.0, *)
struct InventoryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: MicrowaveDataStore
    
    @State private var partID: String = ""
    @State private var change: String = ""
    @State private var reason: String = ""
    @State private var recordedBy: String = "Technician"
    @State private var approvalStatus: String = "Pending"
    @State private var verifiedBy: String = ""
    @State private var previousQuantity: String = ""
    @State private var newQuantity: String = ""
    @State private var location: String = ""
    @State private var batchNumber: String = ""
    @State private var referenceDoc: String = ""
    @State private var costImpact: String = ""
    @State private var remarks: String = ""
    @State private var transactionType: String = "Inbound"
    @State private var department: String = "Warehouse"
    @State private var shift: String = "Morning"
    @State private var temperature: String = ""
    @State private var humidity: String = ""
    @State private var barcode: String = ""
    @State private var supervisor: String = ""
    @State private var inspectionStatus: String = "Pending"
    @State private var auditFlag: Bool = false
    @State private var photoName: String = ""
    @State private var category: String = "Part"
    @State private var storageArea: String = ""
    @State private var shelfNumber: String = ""
    @State private var labelColor: String = "Blue"
    @State private var recordSource: String = "Manual"
    @State private var deviceName: String = "iPad"
    
    @State private var recordedAt: Date = Date()
    @State private var verificationDate: Date? = nil
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // MARK: - Section 1: Transaction & Quantities
                    InventoryAddSectionHeaderView(title: "Transaction & Quantities", iconName: "arrow.up.arrow.down.circle.fill")
                    
                    VStack(spacing: 15) {
                        InventoryAddFieldView(title: "Part ID (UUID)", text: $partID, icon: "cube.fill")
                        InventoryAddFieldView(title: "Quantity Change", text: $change, icon: "plus.minus.circle.fill", keyboardType: .numberPad)
                        InventoryAddSegmentedView(title: "Transaction Type", selection: $transactionType, options: ["Inbound", "Outbound", "Adjustment"], icon: "arrow.left.arrow.right")
                        InventoryAddFieldView(title: "Reason for Change", text: $reason, icon: "questionmark.circle.fill")
                        InventoryAddFieldView(title: "Previous Quantity", text: $previousQuantity, icon: "number.square.fill", keyboardType: .numberPad)
                        InventoryAddFieldView(title: "New Quantity", text: $newQuantity, icon: "number.square.fill", keyboardType: .numberPad)
                    }
                    
                    // MARK: - Section 2: Location & Tracking
                    InventoryAddSectionHeaderView(title: "Location & Tracking", iconName: "map.fill")
                    
                    VStack(spacing: 15) {
                        InventoryAddFieldView(title: "Storage Location", text: $location, icon: "mappin.and.ellipse")
                        InventoryAddFieldView(title: "Storage Area", text: $storageArea, icon: "building.2.fill")
                        InventoryAddFieldView(title: "Shelf Number", text: $shelfNumber, icon: "tray.fill")
                        InventoryAddFieldView(title: "Batch Number", text: $batchNumber, icon: "barcode.fill")
                        InventoryAddFieldView(title: "Barcode", text: $barcode, icon: "barcode.viewfinder")
                        InventoryAddFieldView(title: "Reference Document", text: $referenceDoc, icon: "doc.text.fill")
                        InventoryAddFieldView(title: "Category", text: $category, icon: "folder.fill")
                        InventoryAddFieldView(title: "Label Color", text: $labelColor, icon: "paintpalette.fill")
                    }
                    
                    // MARK: - Section 3: Audit & Environment
                    InventoryAddSectionHeaderView(title: "Audit & Environment", iconName: "person.3.fill")

                    VStack(spacing: 15) {
                        InventoryAddFieldView(title: "Recorded By", text: $recordedBy, icon: "person.fill")
                        InventoryAddFieldView(title: "Verified By", text: $verifiedBy, icon: "checkmark.seal.fill")
                        InventoryAddFieldView(title: "Supervisor", text: $supervisor, icon: "person.2.fill")
                        InventoryAddSegmentedView(title: "Approval Status", selection: $approvalStatus, options: ["Pending", "Approved", "Rejected"], icon: "hand.raised.fill")
                        InventoryAddSegmentedView(title: "Inspection Status", selection: $inspectionStatus, options: ["Pending", "Passed", "Failed"], icon: "eye.fill")
                        InventoryAddSegmentedView(title: "Shift", selection: $shift, options: ["Morning", "Evening", "Night"], icon: "sun.max.fill")
                        InventoryAddToggleView(title: "Audit Flag", isOn: $auditFlag, icon: "flag.fill")
                        
                        InventoryAddFieldView(title: "Temperature (C)", text: $temperature, icon: "thermometer", keyboardType: .decimalPad)
                        InventoryAddFieldView(title: "Humidity (%)", text: $humidity, icon: "drop.fill", keyboardType: .decimalPad)
                        InventoryAddDatePickerView(title: "Record Date", date: $recordedAt, icon: "calendar")
                    }
                    
                    // MARK: - Remarks
                    InventoryAddFieldView(title: "Remarks", text: $remarks, icon: "note.text", isMultiline: true)
                    
                    InventoryAddButtonView(action: saveRecord)
                        .padding(.top, 10)
                }
                .padding()
            }
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle("New Inventory Record")
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Record Status"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        // Dismiss only if success
                        if alertMessage.contains("successfully") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - Save Logic
    private func saveRecord() {
        var errors: [String] = []
        
        // ✅ Validate UUID
        var partUUID: UUID? = nil
        if let uuid = UUID(uuidString: partID) {
            partUUID = uuid
        } else {
            errors.append("Invalid Part ID format (Must be a valid UUID).")
        }
        
        // ✅ Validate numeric fields
        var changeInt: Int?
        var prevQty: Int?
        var newQty: Int?
        var cost: Double?
        
        if let c = Int(change) { changeInt = c } else { errors.append("Quantity Change must be a valid number.") }
        if let p = Int(previousQuantity) { prevQty = p } else { errors.append("Previous Quantity must be a valid number.") }
        if let n = Int(newQuantity) { newQty = n } else { errors.append("New Quantity must be a valid number.") }
        if let ci = Double(costImpact) { cost = ci } else { errors.append("Cost Impact must be a valid number.") }
        
        // ✅ Validate required fields
        if reason.isEmpty { errors.append("Reason is required.") }
        if recordedBy.isEmpty { errors.append("Recorded By is required.") }
        if location.isEmpty { errors.append("Location is required.") }
        if department.isEmpty { errors.append("Department is required.") }
        if temperature.isEmpty || humidity.isEmpty { errors.append("Temperature and Humidity are required.") }

        // ✅ Show alert for errors
        guard errors.isEmpty else {
            alertMessage = "Please correct the following errors:\n" + errors.joined(separator: "\n")
            showingAlert = true
            return
        }

        // ✅ Create and save new record
        let newRecord = InventoryRecord(
            id: UUID(),
            partID: partUUID!,
            change: changeInt!,
            reason: reason,
            recordedBy: recordedBy,
            recordedAt: recordedAt,
            approvalStatus: approvalStatus,
            verifiedBy: verifiedBy,
            verificationDate: verificationDate,
            previousQuantity: prevQty!,
            newQuantity: newQty!,
            location: location,
            batchNumber: batchNumber,
            referenceDoc: referenceDoc,
            costImpact: cost!,
            remarks: remarks,
            transactionType: transactionType,
            department: department,
            shift: shift,
            temperature: Double(temperature) ?? 0.0,
            humidity: Double(humidity) ?? 0.0,
            barcode: barcode,
            supervisor: supervisor,
            inspectionStatus: inspectionStatus,
            auditFlag: auditFlag,
            photoName: photoName,
            category: category,
            storageArea: storageArea,
            shelfNumber: shelfNumber,
            labelColor: labelColor,
            recordSource: recordSource,
            deviceName: deviceName,
            sessionID: UUID().uuidString,
            uploaded: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        dataStore.addInventoryRecord(newRecord)
        alertMessage = "Inventory Record successfully added."
        showingAlert = true
    }
}


@available(iOS 14.0, *)
struct InventoryAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentBlue)
                .font(.headline)
            Text(title)
                .font(.headline)
                .foregroundColor(.darkText)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct InventoryAddFieldView: View {
    let title: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
                .offset(y: text.isEmpty ? 10 : 0)
                .animation(.easeOut(duration: 0.15), value: text.isEmpty)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentBlue)
                    .padding(.leading, 8)
                
                if isMultiline {
                    TextEditor(text: $text)
                        .frame(minHeight: 80)
                        .keyboardType(keyboardType)
                } else {
                    TextField("", text: $text)
                        .foregroundColor(.darkText)
                        .keyboardType(keyboardType)
                }
            }
            .padding(.vertical, isMultiline ? 4 : 8)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.lightGray, lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct InventoryAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentBlue)
                    .padding(.leading, 8)
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                
                Spacer()
            }
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.lightGray, lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct InventoryAddSegmentedView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentBlue)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.darkText)
            }
            .padding(.horizontal)
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct InventoryAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentBlue)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.darkText)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.lightGray, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct InventoryAddButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Save Inventory Record")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentBlue)
                .cornerRadius(15)
                .shadow(color: Color.accentBlue.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct InventoryListView: View {
    @ObservedObject var dataStore: MicrowaveDataStore
    @State private var showingAddView = false
    @State private var searchText = ""
    
    var filteredRecords: [InventoryRecord] {
        if searchText.isEmpty {
            return dataStore.inventoryRecords
        } else {
            return dataStore.inventoryRecords.filter { record in
                record.reason.localizedCaseInsensitiveContains(searchText) ||
                record.recordedBy.localizedCaseInsensitiveContains(searchText) ||
                record.batchNumber.localizedCaseInsensitiveContains(searchText) ||
                record.transactionType.localizedCaseInsensitiveContains(searchText) ||
                record.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                InventorySearchBarView(searchText: $searchText)
                    .padding(.horizontal)
                
                if filteredRecords.isEmpty {
                    InventoryNoDataView(message: searchText.isEmpty ? "No inventory records found. Tap '+' to add one." : "No results for '\(searchText)'")
                } else {
                    List {
                        ForEach(filteredRecords) { record in
                            NavigationLink(destination: InventoryDetailView(record: record)) {
                                InventoryListRowView(record: record)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowBackground(Color.primaryBackground)
                        }
                        .onDelete(perform: deleteRecords)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle("Inventory Logs")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showingAddView) {
                InventoryAddView(dataStore : dataStore)
            }
        
    }
    
    private var addButton: some View {
        Button(action: {
            self.showingAddView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundColor(.accentBlue)
        }
    }
    
    private func deleteRecords(offsets: IndexSet) {
        dataStore.deleteInventoryRecord(at: offsets)
    }
}

@available(iOS 14.0, *)
struct InventorySearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isEditing ? .accentBlue : .gray)
                .padding(.leading, 8)
                .animation(.easeOut(duration: 0.2), value: isEditing)

            TextField("Search by reason, batch, location...", text: $searchText, onEditingChanged: { editing in
                self.isEditing = editing
            })
            .padding(.vertical, 10)
            .foregroundColor(.darkText)
            
            if isEditing {
                Button(action: {
                    self.searchText = ""
                    self.isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
                .transition(.scale)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct InventoryListRowView: View {
    let record: InventoryRecord
    
    var isIncoming: Bool {
        record.transactionType == "Inbound"
    }
    
    var statusColor: Color {
        switch record.approvalStatus {
        case "Approved": return .successGreen
        case "Pending": return .warningOrange
        default: return .dangerRed
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.reason)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.darkText)
                    
                    Text("\(record.transactionType) | \(record.department)")
                        .font(.caption)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(isIncoming ? Color.successGreen.opacity(0.15) : Color.dangerRed.opacity(0.15))
                        .foregroundColor(isIncoming ? Color.successGreen : Color.dangerRed)
                        .cornerRadius(6)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(isIncoming ? "+" : "-") \(record.change)")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(isIncoming ? .successGreen : .dangerRed)
                    
                    Text("New Qty: \(record.newQuantity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider().padding(.horizontal, -10)
            
            VStack(spacing: 8) {
                HStack {
                    InventoryListDetailItem(icon: "tag.fill", label: "Category", value: record.category)
                    Spacer()
                    InventoryListDetailItem(icon: "person.fill", label: "Recorded By", value: record.recordedBy)
                }
                
                HStack {
                    InventoryListDetailItem(icon: "mappin.and.ellipse", label: "Location", value: "\(record.location) / \(record.shelfNumber)")
                    Spacer()
                    InventoryListDetailItem(icon: "doc.text", label: "Reference", value: record.referenceDoc.isEmpty ? "N/A" : record.referenceDoc)
                }
                
                HStack {
                    InventoryListDetailItem(icon: "dollarsign.circle.fill", label: "Cost Impact", value: String(format: "$%.2f", record.costImpact))
                    Spacer()
                    InventoryListDetailItem(icon: "clock.fill", label: "Time", value: DateFormatter.fullDateTime.string(from: record.recordedAt))
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(statusColor)
                    Text("Approval: \(record.approvalStatus)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.darkText)
                }
                
                Spacer()
                
                Text("Batch: \(record.batchNumber.isEmpty ? "N/A" : record.batchNumber)")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct InventoryListDetailItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.accentBlue)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
    }
}

@available(iOS 14.0, *)
struct InventoryNoDataView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "archivebox.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.lightGray)
            
            Text("No Records")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.darkText)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct InventoryDetailView: View {
    let record: InventoryRecord
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                InventoryDetailHeaderView(record: record)
                
                InventoryDetailBlockView(title: "Transaction Core Data", icon: "arrow.up.arrow.down.circle.fill") {
                    VStack(spacing: 15) {
                        InventoryDetailFieldRow(label: "Part ID (UUID)", value: record.partID.uuidString, icon: "barcode.fill")
                        InventoryDetailFieldRow(label: "Change Amount", value: "\(record.change)", icon: "plus.minus")
                        InventoryDetailFieldRow(label: "Transaction Type", value: record.transactionType, icon: "arrow.left.arrow.right")
                        InventoryDetailFieldRow(label: "Reason", value: record.reason, icon: "doc.text")
                        InventoryDetailFieldRow(label: "Cost Impact", value: String(format: "$%.2f", record.costImpact), icon: "dollarsign.circle.fill")
                        InventoryDetailFieldRow(label: "Reference Document", value: record.referenceDoc, icon: "paperclip")
                        InventoryDetailFieldRow(label: "Category", value: record.category, icon: "folder.fill")
                    }
                }
                
                InventoryDetailBlockView(title: "Quantity & Stock Levels", icon: "cube.box.fill") {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 15) {
                            InventoryDetailFieldRow(label: "Previous Quantity", value: "\(record.previousQuantity)", icon: "square.stack.3d.down.right.fill")
                            InventoryDetailFieldRow(label: "New Quantity", value: "\(record.newQuantity)", icon: "square.stack.3d.up.fill")
                            InventoryDetailFieldRow(label: "Batch Number", value: record.batchNumber, icon: "number.square.fill")
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            InventoryDetailFieldRow(label: "Location Bin", value: record.location, icon: "mappin.and.ellipse")
                            InventoryDetailFieldRow(label: "Storage Area", value: record.storageArea, icon: "building.2.fill")
                            InventoryDetailFieldRow(label: "Shelf Number", value: record.shelfNumber, icon: "tray.fill")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                InventoryDetailBlockView(title: "Audit & Personnel", icon: "person.3.fill") {
                    VStack(spacing: 15) {
                        InventoryDetailFieldRow(label: "Recorded By / Supervisor", value: "\(record.recordedBy) / \(record.supervisor)", icon: "person.fill")
                        InventoryDetailFieldRow(label: "Verified By", value: record.verifiedBy.isEmpty ? "N/A" : record.verifiedBy, icon: "checkmark.seal.fill")
                        InventoryDetailFieldRow(label: "Recorded At", value: DateFormatter.fullDateTime.string(from: record.recordedAt), icon: "calendar.badge.clock")
                        InventoryDetailFieldRow(label: "Verification Date", value: record.verificationDate != nil ? DateFormatter.shortDate.string(from: record.verificationDate!) : "Pending", icon: "calendar.badge.checkmark")
                        InventoryDetailFieldRow(label: "Department / Shift", value: "\(record.department) / \(record.shift)", icon: "briefcase.fill")
                        InventoryDetailFieldRow(label: "Approval Status", value: record.approvalStatus, icon: "hand.raised.fill")
                        InventoryDetailFieldRow(label: "Inspection Status", value: record.inspectionStatus, icon: "eye.fill")
                        InventoryDetailFieldRow(label: "Audit Flag", value: record.auditFlag ? "Yes" : "No", icon: "flag.fill")
                    }
                }
                
                InventoryDetailBlockView(title: "Environment & System Data", icon: "desktopcomputer") {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 15) {
                            InventoryDetailFieldRow(label: "Temperature", value: String(format: "%.1f°C", record.temperature), icon: "thermometer")
                            InventoryDetailFieldRow(label: "Humidity", value: String(format: "%.1f%%", record.humidity), icon: "drop.fill")
                            InventoryDetailFieldRow(label: "Barcode", value: record.barcode.isEmpty ? "N/A" : record.barcode, icon: "barcode.viewfinder")
                            InventoryDetailFieldRow(label: "Photo Name", value: record.photoName.isEmpty ? "N/A" : record.photoName, icon: "photo.fill")
                            InventoryDetailFieldRow(label: "Label Color", value: record.labelColor, icon: "paintpalette.fill")

                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            InventoryDetailFieldRow(label: "Record Source", value: record.recordSource, icon: "square.and.arrow.down.fill")
                            InventoryDetailFieldRow(label: "Device Name", value: record.deviceName, icon: "iphone")
                            InventoryDetailFieldRow(label: "Session ID", value: record.sessionID.prefix(10) + "...", icon: "link")
                            InventoryDetailFieldRow(label: "Uploaded", value: record.uploaded ? "Yes" : "No", icon: "icloud.and.arrow.up.fill")
                            InventoryDetailFieldRow(label: "Created At", value: DateFormatter.fullDateTime.string(from: record.createdAt), icon: "clock.fill")
                            InventoryDetailFieldRow(label: "Updated At", value: DateFormatter.fullDateTime.string(from: record.updatedAt), icon: "arrow.clockwise")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                InventoryDetailBlockView(title: "Remarks", icon: "note.text") {
                    Text(record.remarks.isEmpty ? "No remarks provided for this transaction." : record.remarks)
                        .font(.body)
                        .foregroundColor(.darkText)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.lightGray)
                        .cornerRadius(8)
                }
                
            }
            .padding()
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Record Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 14.0, *)
struct InventoryDetailHeaderView: View {
    let record: InventoryRecord
    
    var statusColor: Color {
        switch record.approvalStatus {
        case "Approved": return .successGreen
        case "Pending": return .warningOrange
        default: return .dangerRed
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: record.transactionType == "Inbound" ? "arrow.up.left.and.arrow.down.right" : "arrow.down.right.and.arrow.up.left")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(record.transactionType == "Inbound" ? .successGreen : .dangerRed)
                .padding(.bottom, 5)
            
            Text(record.reason)
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.darkText)
                .multilineTextAlignment(.center)
            
            Text("Batch: \(record.batchNumber.isEmpty ? "N/A" : record.batchNumber) | \(record.category)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider().padding(.vertical, 5)
            
            HStack {
                VStack {
                    Text("Approval Status")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(record.approvalStatus)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(statusColor)
                }
                Spacer()
                VStack {
                    Text("Cost Impact")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(String(format: "$%.2f", record.costImpact))
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

@available(iOS 14.0, *)
struct InventoryDetailBlockView<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content
    
    init(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentBlue)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.darkText)
            }
            .padding(.bottom, 5)
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.lightGray, lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct InventoryDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.accentBlue)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.darkText)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
        }
    }
}
