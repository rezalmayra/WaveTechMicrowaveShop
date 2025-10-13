import SwiftUI
import Combine


@available(iOS 14.0, *)
struct MaintenanceTemplateAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.blue)
                .cornerRadius(8)
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateAddFieldView: View {
    let title: String
    @Binding var text: String
    let iconName: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = true

    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                ZStack(alignment: .leading) {
                    Text(title + (isRequired ? " *" : ""))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .offset(y: isEditing || !text.isEmpty ? -20 : 0)
                        .scaleEffect(isEditing || !text.isEmpty ? 1.0 : 1.1, anchor: .leading)
                    
                    TextField("", text: $text, onEditingChanged: { editing in
                        withAnimation(.spring()) {
                            self.isEditing = editing
                        }
                    })
                    .keyboardType(keyboardType)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(isEditing ? .blue : Color.gray.opacity(0.3))
                .cornerRadius(1)
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateAddDatePickerView: View {
    let title: String
    @Binding var date: Date?
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 10)

            DatePicker(
                title,
                selection: Binding(
                    get: { self.date ?? Date() },
                    set: { self.date = $0 }
                ),
                displayedComponents: .date
            )
            .labelsHidden()
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)

            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.gray.opacity(0.3))
                .cornerRadius(1)
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateAddBoolPickerView: View {
    let title: String
    @Binding var value: Bool
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)

                Toggle(title, isOn: $value)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)

            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.gray.opacity(0.3))
                .cornerRadius(1)
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: MicrowaveDataStore

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var modelType: String = ""
    @State private var version: String = ""
    @State private var steps: String = ""
    @State private var recommendedIntervalDays: String = ""
    @State private var estimatedDurationMinutes: String = ""
    @State private var difficultyLevel: String = ""
    @State private var toolsRequired: String = ""
    @State private var safetyPrecautions: String = ""
    @State private var partsRequired: String = ""
    @State private var createdBy: String = ""
    @State private var approvedBy: String = ""
    @State private var approvalDate: Date? = nil
    @State private var reviewDate: Date? = nil
    @State private var rating: String = ""
    @State private var usageCount: String = ""
    @State private var lastUsedDate: Date? = nil
    @State private var nextReviewDate: Date? = nil
    @State private var remarks: String = ""
    @State private var tag: String = ""
    @State private var active: Bool = true
    @State private var associatedModel: String = ""
    @State private var maintenanceType: String = ""
    @State private var department: String = ""
    @State private var versionNotes: String = ""
    @State private var language: String = ""
    @State private var country: String = ""
    @State private var estimatedCost: String = ""
    @State private var warrantyRequired: Bool = false
    @State private var lastUpdatedBy: String = ""
    @State private var createdAt: Date = Date()
    @State private var updatedAt: Date = Date()

    // MARK: - Alert States
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // MARK: - Helper Functions
    private func stringToArray(text: String) -> [String] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    // MARK: - Save Template Logic
    private func saveTemplate() {
        // Step 1: Show a small note first
        alertMessage = "📝 Note: Please review your details before saving."
        showAlert = true

        // Step 2: After a short delay, validate and save
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            var errors: [String] = []

            if name.isEmpty { errors.append("Template Name is required.") }
            if category.isEmpty { errors.append("Category is required.") }
            if modelType.isEmpty { errors.append("Model Type is required.") }
            if version.isEmpty { errors.append("Version is required.") }
            if recommendedIntervalDays.isEmpty || Int(recommendedIntervalDays) == nil { errors.append("Valid Interval Days is required.") }
            if estimatedDurationMinutes.isEmpty || Int(estimatedDurationMinutes) == nil { errors.append("Valid Duration (Minutes) is required.") }
            if difficultyLevel.isEmpty { errors.append("Difficulty Level is required.") }
            if createdBy.isEmpty { errors.append("Created By is required.") }
            if approvedBy.isEmpty { errors.append("Approved By is required.") }
            if associatedModel.isEmpty { errors.append("Associated Model is required.") }
            if maintenanceType.isEmpty { errors.append("Maintenance Type is required.") }
            if department.isEmpty { errors.append("Department is required.") }
            if language.isEmpty { errors.append("Language is required.") }
            if country.isEmpty { errors.append("Country is required.") }
            if estimatedCost.isEmpty || Double(estimatedCost) == nil { errors.append("Valid Estimated Cost is required.") }
            if lastUpdatedBy.isEmpty { errors.append("Last Updated By is required.") }
            if rating.isEmpty || Int(rating) == nil { errors.append("Valid Rating (1–5) is required.") }
            if usageCount.isEmpty || Int(usageCount) == nil { errors.append("Valid Usage Count is required.") }

            // Step 3: Handle validation errors
            guard errors.isEmpty else {
                alertMessage = "⚠️ Please correct the following issues:\n\n" + errors.joined(separator: "\n")
                showAlert = true
                return
            }

            // Step 4: Create and save template
            let newTemplate = MaintenanceTemplate(
                name: name,
                category: category,
                modelType: modelType,
                version: version,
                steps: stringToArray(text: steps),
                recommendedIntervalDays: Int(recommendedIntervalDays) ?? 0,
                estimatedDurationMinutes: Int(estimatedDurationMinutes) ?? 0,
                difficultyLevel: difficultyLevel,
                toolsRequired: stringToArray(text: toolsRequired),
                safetyPrecautions: stringToArray(text: safetyPrecautions),
                partsRequired: stringToArray(text: partsRequired),
                createdBy: createdBy,
                approvedBy: approvedBy,
                approvalDate: approvalDate,
                reviewDate: reviewDate,
                rating: Int(rating) ?? 0,
                usageCount: Int(usageCount) ?? 0,
                lastUsedDate: lastUsedDate,
                nextReviewDate: nextReviewDate,
                remarks: remarks,
                tag: tag,
                active: active,
                associatedModel: associatedModel,
                maintenanceType: maintenanceType,
                department: department,
                versionNotes: versionNotes,
                language: language,
                country: country,
                estimatedCost: Double(estimatedCost) ?? 0.0,
                warrantyRequired: warrantyRequired,
                lastUpdatedBy: lastUpdatedBy,
                createdAt: createdAt,
                updatedAt: updatedAt
            )

            dataStore.addMaintenanceTemplate(newTemplate)
            alertMessage = "✅ Success! The template '\(name)' was saved successfully."
            showAlert = true
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // SECTION 1: Primary Details
                    MaintenanceTemplateAddSectionHeaderView(title: "Primary Details", iconName: "wrench.and.screwdriver.fill")
                    VStack(spacing: 15) {
                        MaintenanceTemplateAddFieldView(title: "Template Name", text: $name, iconName: "doc.text.fill")
                        MaintenanceTemplateAddFieldView(title: "Category", text: $category, iconName: "folder.fill")
                        MaintenanceTemplateAddFieldView(title: "Model Type", text: $modelType, iconName: "microwave.fill")
                        MaintenanceTemplateAddFieldView(title: "Associated Model", text: $associatedModel, iconName: "tag.fill")
                    }

                    // SECTION 2: Timing & Scope
                    MaintenanceTemplateAddSectionHeaderView(title: "Timing & Scope", iconName: "clock.fill")
                    VStack(spacing: 15) {
                        HStack {
                            MaintenanceTemplateAddFieldView(title: "Interval (Days)", text: $recommendedIntervalDays, iconName: "repeat", keyboardType: .numberPad)
                            MaintenanceTemplateAddFieldView(title: "Duration (Min)", text: $estimatedDurationMinutes, iconName: "timer", keyboardType: .numberPad)
                        }
                        MaintenanceTemplateAddFieldView(title: "Difficulty Level", text: $difficultyLevel, iconName: "flame.fill")
                        MaintenanceTemplateAddFieldView(title: "Maintenance Type", text: $maintenanceType, iconName: "list.bullet.indent")
                        MaintenanceTemplateAddFieldView(title: "Steps (Comma Separated)", text: $steps, iconName: "list.number")
                        MaintenanceTemplateAddFieldView(title: "Tools Required", text: $toolsRequired, iconName: "wrench.fill")
                        MaintenanceTemplateAddFieldView(title: "Safety Precautions", text: $safetyPrecautions, iconName: "shield.lefthalf.fill")
                        MaintenanceTemplateAddFieldView(title: "Parts Required (Comma Separated)", text: $partsRequired, iconName: "puzzlepiece.fill")
                    }

                    // SECTION 3: Personnel & Status
                    MaintenanceTemplateAddSectionHeaderView(title: "Personnel & Status", iconName: "person.3.fill")
                    VStack(spacing: 15) {
                        HStack {
                            MaintenanceTemplateAddFieldView(title: "Created By", text: $createdBy, iconName: "person.fill")
                            MaintenanceTemplateAddFieldView(title: "Approved By", text: $approvedBy, iconName: "checkmark.seal.fill")
                        }
                        HStack {
                            MaintenanceTemplateAddFieldView(title: "Last Updated By", text: $lastUpdatedBy, iconName: "pencil.circle.fill")
                            MaintenanceTemplateAddFieldView(title: "Department", text: $department, iconName: "building.2.fill")
                        }
                        HStack {
                            MaintenanceTemplateAddDatePickerView(title: "Approval Date", date: $approvalDate, iconName: "calendar.badge.checkmark")
                            MaintenanceTemplateAddDatePickerView(title: "Next Review Date", date: $nextReviewDate, iconName: "arrow.clockwise.icloud.fill")
                        }
                        HStack {
                            MaintenanceTemplateAddDatePickerView(title: "Last Used Date", date: $lastUsedDate, iconName: "calendar.badge.clock")
                            MaintenanceTemplateAddDatePickerView(title: "Review Date", date: $reviewDate, iconName: "arrow.uturn.backward")
                        }
                        MaintenanceTemplateAddFieldView(title: "Version", text: $version, iconName: "number.circle.fill")
                        MaintenanceTemplateAddFieldView(title: "Version Notes", text: $versionNotes, iconName: "doc.text")
                    }

                    // SECTION 4: Financial & Audit
                    MaintenanceTemplateAddSectionHeaderView(title: "Financial & Audit", iconName: "dollarsign.circle.fill")
                    VStack(spacing: 15) {
                        HStack {
                            MaintenanceTemplateAddFieldView(title: "Estimated Cost", text: $estimatedCost, iconName: "tag.fill", keyboardType: .decimalPad)
                            MaintenanceTemplateAddFieldView(title: "Rating (1-5)", text: $rating, iconName: "star.fill", keyboardType: .numberPad)
                        }
                        HStack {
                            MaintenanceTemplateAddFieldView(title: "Usage Count", text: $usageCount, iconName: "chart.line.uptrend.xyaxis", keyboardType: .numberPad)
                            MaintenanceTemplateAddFieldView(title: "Tag", text: $tag, iconName: "link.circle.fill")
                        }
                        HStack {
                            MaintenanceTemplateAddFieldView(title: "Language", text: $language, iconName: "globe")
                            MaintenanceTemplateAddFieldView(title: "Country", text: $country, iconName: "flag.fill")
                        }
                        MaintenanceTemplateAddFieldView(title: "Remarks", text: $remarks, iconName: "note.text", isRequired: false)
                        HStack {
                            MaintenanceTemplateAddBoolPickerView(title: "Warranty Required", value: $warrantyRequired, iconName: "shield.lefthalf.fill")
                            MaintenanceTemplateAddBoolPickerView(title: "Active", value: $active, iconName: "power")
                        }
                    }

                    // SAVE BUTTON
                    Button(action: saveTemplate) {
                        Text("Save New Template")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue)
                                    .shadow(radius: 5)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("New Maintenance Template")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Form Message"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("Success") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.orange)
            
            Text("No Maintenance Templates Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Try adding a new template using the '+' button above.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(50)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding()
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search templates, models, or types...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing && !searchText.isEmpty {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateListRowView: View {
    let template: MaintenanceTemplate
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        return MaintenanceTemplateListRowView.dateFormatter.string(from: date)
    }
    
    private var firstStep: String {
        template.steps.first ?? "No steps defined"
    }
    
    private var firstTool: String {
        template.toolsRequired.first ?? "N/A"
    }
    
    private var firstPrecaution: String {
        template.safetyPrecautions.first ?? "N/A"
    }
    
    private var firstPart: String {
        template.partsRequired.first ?? "N/A"
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            HStack {
                Image(systemName: template.active ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .foregroundColor(template.active ? .green : .red)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(template.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text("v\(template.version)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(template.tag.uppercased())
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 6)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(5)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < template.rating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
            .padding([.horizontal, .top], 15)
            .padding(.bottom, 8)
            .background(Color(UIColor.systemGray6))
            
            // MARK: - Core Information
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Model: **\(template.associatedModel)**")
                        Text("Category: \(template.category)")
                        Text("Type: \(template.maintenanceType)")
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Est. Duration: \(template.estimatedDurationMinutes) min")
                            .font(.caption)
                            .foregroundColor(.purple)
                        Text("Cost: $\(String(format: "%.2f", template.estimatedCost))")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text("Interval: **\(template.recommendedIntervalDays) days**")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                    Text("Last Used: \(formattedDate(template.lastUsedDate))")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "calendar.badge.plus")
                        .foregroundColor(.pink)
                    Text("Next Review: \(formattedDate(template.nextReviewDate))")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "calendar.badge.checkmark")
                        .foregroundColor(.green)
                    Text("Approval: \(formattedDate(template.approvalDate))")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Difficulty: \(template.difficultyLevel)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .foregroundColor(.gray)
                    Text("Tool: \(firstTool)")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.blue)
                    Text("Safety: \(firstPrecaution)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "cube.fill")
                        .foregroundColor(.purple)
                    Text("Part: \(firstPart)")
                        .font(.caption)
                }
                
                Divider()
                
                // MARK: - Management and Tracking
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text("Created: \(template.createdBy)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .foregroundColor(.green)
                    Text("Approved: \(template.approvedBy)")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "person.crop.circle.fill.badge.clock")
                        .foregroundColor(.orange)
                    Text("Updated By: \(template.lastUpdatedBy)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.gray)
                    Text("Usage: \(template.usageCount)x")
                        .font(.caption)
                }
                
                Divider()
                
                // MARK: - Additional Metadata
                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.blue)
                    Text("Country: \(template.country)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "globe")
                        .foregroundColor(.green)
                    Text("Lang: \(template.language)")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: template.warrantyRequired ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .foregroundColor(template.warrantyRequired ? .green : .red)
                    Text("Warranty Required: \(template.warrantyRequired ? "Yes" : "No")")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.pink)
                    Text("Dept: \(template.department)")
                        .font(.caption)
                }
                
                Divider()
                
                // MARK: - Descriptions and Notes
                VStack(alignment: .leading, spacing: 4) {
                    Text("Remarks:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(template.remarks.isEmpty ? "N/A" : template.remarks)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("Version Notes:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.top, 2)
                    Text(template.versionNotes.isEmpty ? "N/A" : template.versionNotes)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("Next Step: \(firstStep)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .lineLimit(1)
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
        }
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}


@available(iOS 14.0, *)
struct MaintenanceTemplateListView: View {
    @ObservedObject var dataStore: MicrowaveDataStore
    @State private var isShowingAddView: Bool = false
    @State private var searchText: String = ""

    private var filteredTemplates: [MaintenanceTemplate] {
        if searchText.isEmpty {
            return dataStore.maintenanceTemplates
        } else {
            return dataStore.maintenanceTemplates.filter { template in
                template.name.localizedCaseInsensitiveContains(searchText) ||
                template.associatedModel.localizedCaseInsensitiveContains(searchText) ||
                template.maintenanceType.localizedCaseInsensitiveContains(searchText) ||
                template.tag.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        dataStore.deleteMaintenanceTemplate(at: offsets)
    }

    var body: some View {
            VStack {
                MaintenanceTemplateSearchBarView(searchText: $searchText)
                    .padding(.vertical, 8)
                
                if filteredTemplates.isEmpty {
                    Spacer()
                    MaintenanceTemplateNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTemplates) { template in
                            ZStack {
                                MaintenanceTemplateListRowView(template: template)
                                
                                NavigationLink(destination: MaintenanceTemplateDetailView(template: template)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowInsets(EdgeInsets())
                            .background(Color.clear)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Maintenance Templates")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $isShowingAddView) {
                MaintenanceTemplateAddView(dataStore : dataStore)
            }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    let color: Color

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(color)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateDetailBlock: View {
    let title: String
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.bottom, 5)
            
            Divider()
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateDetailView: View {
    let template: MaintenanceTemplate

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        return MaintenanceTemplateDetailView.dateFormatter.string(from: date)
    }
    
    private func arrayToString(_ array: [String]) -> String {
        array.isEmpty ? "None" : array.joined(separator: ", ")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(template.name)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            
                            Text("Model: \(template.associatedModel) | Type: \(template.maintenanceType) | V\(template.version)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "list.clipboard.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Difficulty: **\(template.difficultyLevel)**")
                                .font(.callout)
                                .foregroundColor(.white)
                            Text("Rating: \(template.rating)/5")
                                .font(.callout)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Cost: **$\(String(format: "%.2f", template.estimatedCost))**")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(15)
                .padding(.horizontal, 10)

                MaintenanceTemplateDetailBlock(title: "Core Specifications", iconName: "gearshape.fill")
                    .padding(.horizontal, 10)

                VStack(spacing: 0) {
                    HStack {
                        MaintenanceTemplateDetailFieldRow(label: "Category", value: template.category, iconName: "folder.fill", color: .green)
                        Spacer()
                        MaintenanceTemplateDetailFieldRow(label: "Usage Count", value: "\(template.usageCount)", iconName: "chart.line.uptrend.xyaxis", color: .yellow)
                    }
                    HStack {
                        MaintenanceTemplateDetailFieldRow(label: "Language", value: template.language, iconName: "globe", color: .pink)
                        Spacer()
                        MaintenanceTemplateDetailFieldRow(label: "Country", value: template.country, iconName: "flag.fill", color: .pink)
                    }
                }
                .padding(.horizontal, 10)
                
                MaintenanceTemplateDetailBlock(title: "Timing & Logistics", iconName: "timer")
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        MaintenanceTemplateDetailFieldRow(label: "Interval", value: "\(template.recommendedIntervalDays) days", iconName: "repeat", color: .blue)
                        MaintenanceTemplateDetailFieldRow(label: "Duration", value: "\(template.estimatedDurationMinutes) minutes", iconName: "clock.fill", color: .blue)
                        MaintenanceTemplateDetailFieldRow(label: "Department", value: template.department, iconName: "building.2.fill", color: .blue)
                        MaintenanceTemplateDetailFieldRow(label: "Tag", value: template.tag, iconName: "link.circle.fill", color: .blue)
                    }
                    .padding(.horizontal)
                    .background(Color(UIColor.systemGray6).cornerRadius(8))
                }
                .padding(.horizontal, 10)

                MaintenanceTemplateDetailBlock(title: "Resources Required", iconName: "puzzlepiece.fill")
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    MaintenanceTemplateDetailFieldRow(label: "Tools Required", value: arrayToString(template.toolsRequired), iconName: "wrench.fill", color: .purple)
                    MaintenanceTemplateDetailFieldRow(label: "Parts Required (SKUs)", value: arrayToString(template.partsRequired), iconName: "puzzlepiece.fill", color: .purple)
                    MaintenanceTemplateDetailFieldRow(label: "Safety Precautions", value: arrayToString(template.safetyPrecautions), iconName: "exclamationmark.triangle.fill", color: .purple)
                }
                .padding(.horizontal, 20)

                MaintenanceTemplateDetailBlock(title: "Audit Trail", iconName: "lock.shield.fill")
                    .padding(.horizontal, 10)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        MaintenanceTemplateDetailFieldRow(label: "Created By", value: template.createdBy, iconName: "person.fill", color: .gray)
                        Spacer()
                        MaintenanceTemplateDetailFieldRow(label: "Approved By", value: template.approvedBy, iconName: "person.2.fill", color: .gray)
                    }
                    HStack {
                        MaintenanceTemplateDetailFieldRow(label: "Approval Date", value: formattedDate(template.approvalDate), iconName: "calendar.badge.checkmark", color: .gray)
                        Spacer()
                        MaintenanceTemplateDetailFieldRow(label: "Review Date", value: formattedDate(template.reviewDate), iconName: "arrow.uturn.backward", color: .gray)
                    }
                    HStack {
                        MaintenanceTemplateDetailFieldRow(label: "Last Used Date", value: formattedDate(template.lastUsedDate), iconName: "calendar.badge.clock", color: .gray)
                        Spacer()
                        MaintenanceTemplateDetailFieldRow(label: "Next Review", value: formattedDate(template.nextReviewDate), iconName: "goforward", color: .gray)
                    }
                    HStack {
                        MaintenanceTemplateDetailFieldRow(label: "Last Updated By", value: template.lastUpdatedBy, iconName: "wrench.and.screwdriver.fill", color: .gray)
                        Spacer()
                        MaintenanceTemplateDetailFieldRow(label: "Last Updated At", value: formattedDate(template.updatedAt), iconName: "clock.fill", color: .gray)
                    }
                }
                .padding(.horizontal, 10)

                MaintenanceTemplateDetailBlock(title: "Status & Notes", iconName: "note.text")
                    .padding(.horizontal, 10)

                VStack(alignment: .leading) {
                    MaintenanceTemplateDetailFieldRow(label: "Active", value: template.active ? "Yes" : "No", iconName: template.active ? "power" : "power.slash", color: template.active ? .green : .red)
                    
                    MaintenanceTemplateDetailFieldRow(label: "Warranty Required", value: template.warrantyRequired ? "Yes" : "No", iconName: template.warrantyRequired ? "checkmark.shield.fill" : "xmark.shield.fill", color: template.warrantyRequired ? .green : .red)
                    
                    MaintenanceTemplateDetailFieldRow(label: "Version Notes", value: template.versionNotes.isEmpty ? "None" : template.versionNotes, iconName: "doc.text", color: .orange)
                    
                    MaintenanceTemplateDetailFieldRow(label: "Remarks", value: template.remarks.isEmpty ? "None" : template.remarks, iconName: "text.bubble.fill", color: .orange)
                    
                    MaintenanceTemplateDetailFieldRow(label: "All Steps", value: arrayToString(template.steps), iconName: "list.bullet.rectangle.fill", color: .orange)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 20)

            }
        }
        .navigationTitle("Template Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 14.0, *)
struct MaintenanceTemplateFeatureRootView: View {
    @StateObject var dataStore = MicrowaveDataStore()

    var body: some View {
        MaintenanceTemplateListView(dataStore : dataStore)
    }
}
