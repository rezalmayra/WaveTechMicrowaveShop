
import SwiftUI
import Foundation
import Combine


@available(iOS 14.0, *)
struct WorkLogEntryAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String

    @State private var isEditing: Bool = false
    

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(text.isEmpty && !isEditing ? Color(.placeholderText) : Color.accentColor)
                    .offset(y:  -25)
                    .scaleEffect( 0.8, anchor: .leading)
                    .animation(.spring(), value: text.isEmpty)

                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 8)

                    TextField("", text: $text, onEditingChanged: { editing in
                        isEditing = editing
                    })
                }
                .padding(.top, text.isEmpty && !isEditing ? 0 : 25)
            }

            Divider()
                .frame(height: 1)
                .background(isEditing ? Color.blue : Color.gray.opacity(0.3))
                .animation(.easeInOut, value: isEditing)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryAddNumericFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String

    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(text.isEmpty && !isEditing ? Color(.placeholderText) : Color.accentColor)
                    .offset(y: -25)
                    .scaleEffect(0.8, anchor: .leading)
                    .animation(.spring(), value: text.isEmpty)

                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 8)

                    TextField("", text: $text, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .keyboardType(.numbersAndPunctuation)
                }
                .padding(.top, text.isEmpty && !isEditing ? 0 : 25)
            }

            Divider()
                .frame(height: 1)
                .background(isEditing ? Color.blue : Color.gray.opacity(0.3))
                .animation(.easeInOut, value: isEditing)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    var component: DatePickerComponents = [.date, .hourAndMinute]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)

            DatePicker(title, selection: $date, displayedComponents: component)
                .labelsHidden()
                .padding(.horizontal)
                .datePickerStyle(CompactDatePickerStyle())

            Divider()
                .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 8)

                Toggle(title, isOn: $isOn)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Divider()
                .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange.opacity(0.8))
        )
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: MicrowaveDataStore

    @State private var jobID: UUID = UUID()
    @State private var author: String = ""
    @State private var role: String = ""
    @State private var note: String = ""
    @State private var timestamp: Date = Date()
    @State private var stepNumber: String = ""
    @State private var status: String = "Pending"
    @State private var temperatureReading: String = ""
    @State private var voltageReading: String = ""
    @State private var currentReading: String = ""
    @State private var resistanceReading: String = ""
    @State private var componentReplaced: String = ""
    @State private var partUsed: String = ""
    @State private var timeSpentMinutes: String = ""
    @State private var toolsUsed: String = "Multimeter, Wrench" 
    @State private var imageName: String = ""
    @State private var customerFeedback: String = ""
    @State private var satisfactionLevel: String = "5"
    @State private var warrantyClaim: Bool = false
    @State private var claimStatus: String = "N/A"
    @State private var issueResolved: Bool = false
    @State private var supervisorName: String = ""
    @State private var environmentNote: String = ""
    @State private var humidityLevel: String = ""
    @State private var safetyCheckDone: Bool = false
    @State private var cleanedAfterService: Bool = false
    @State private var nextVisitSuggested: Bool = false
    @State private var nextVisitDate: Date = Date().addingTimeInterval(86400 * 30)
    @State private var additionalCost: String = "0.0"
    @State private var remarks: String = ""
    @State private var signatureName: String = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var newEntryID: UUID?

    private func validateAndSave() {
        var errors: [String] = []

        if author.isEmpty { errors.append("Author is required.") }
        if role.isEmpty { errors.append("Role is required.") }
        if note.isEmpty { errors.append("Note is required.") }
        if status.isEmpty { errors.append("Status is required.") }
        if stepNumber.isEmpty || Int(stepNumber) == nil { errors.append("Step Number must be an integer.") }
        if temperatureReading.isEmpty || Double(temperatureReading) == nil { errors.append("Temperature must be a number.") }
        if voltageReading.isEmpty || Double(voltageReading) == nil { errors.append("Voltage must be a number.") }
        if currentReading.isEmpty || Double(currentReading) == nil { errors.append("Current must be a number.") }
        if resistanceReading.isEmpty || Double(resistanceReading) == nil { errors.append("Resistance must be a number.") }
        if componentReplaced.isEmpty { errors.append("Component Replaced is required.") }
        if partUsed.isEmpty { errors.append("Part Used is required.") }
        if timeSpentMinutes.isEmpty || Int(timeSpentMinutes) == nil { errors.append("Time Spent must be an integer.") }
        if satisfactionLevel.isEmpty || Int(satisfactionLevel) == nil { errors.append("Satisfaction Level must be an integer.") }
        if additionalCost.isEmpty || Double(additionalCost) == nil { errors.append("Additional Cost must be a number.") }
        if humidityLevel.isEmpty || Double(humidityLevel) == nil { errors.append("Humidity Level must be a number.") }


        if errors.isEmpty {
            let newLog = WorkLogEntry(
                jobID: jobID,
                author: author,
                role: role,
                note: note,
                timestamp: timestamp,
                stepNumber: Int(stepNumber) ?? 0,
                status: status,
                temperatureReading: Double(temperatureReading) ?? 0.0,
                voltageReading: Double(voltageReading) ?? 0.0,
                currentReading: Double(currentReading) ?? 0.0,
                resistanceReading: Double(resistanceReading) ?? 0.0,
                componentReplaced: componentReplaced,
                partUsed: partUsed,
                timeSpentMinutes: Int(timeSpentMinutes) ?? 0,
                toolsUsed: toolsUsed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                imageName: imageName,
                customerFeedback: customerFeedback,
                satisfactionLevel: Int(satisfactionLevel) ?? 0,
                warrantyClaim: warrantyClaim,
                claimStatus: claimStatus,
                issueResolved: issueResolved,
                supervisorName: supervisorName,
                environmentNote: environmentNote,
                humidityLevel: Double(humidityLevel) ?? 0.0,
                safetyCheckDone: safetyCheckDone,
                cleanedAfterService: cleanedAfterService,
                nextVisitSuggested: nextVisitSuggested,
                nextVisitDate: nextVisitSuggested ? nextVisitDate : nil,
                additionalCost: Double(additionalCost) ?? 0.0,
                remarks: remarks,
                signatureName: signatureName,
                createdAt: Date(),
                updatedAt: Date()
            )

            dataStore.addWorkLog(newLog)
            newEntryID = newLog.id
            alertTitle = "Success"
            alertMessage = "Work Log successfully added!\nEntry ID: \(newLog.id)"
        } else {
            alertTitle = "Validation Error"
            alertMessage = "Please correct the following errors:\n\n" + errors.joined(separator: "\n")
        }
        showAlert = true
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    
                    WorkLogEntryAddSectionHeaderView(title: "Technician & Timing", iconName: "person.3.fill")

                    VStack(spacing: 15) {
                        WorkLogEntryAddFieldView(title: "Author Name", iconName: "person.fill", text: $author)
                        WorkLogEntryAddFieldView(title: "Role", iconName: "briefcase.fill", text: $role)
                        WorkLogEntryAddFieldView(title: "Supervisor Name", iconName: "eye.fill", text: $supervisorName)
                        WorkLogEntryAddDatePickerView(title: "Timestamp", iconName: "calendar.badge.clock.fill", date: $timestamp)
                        WorkLogEntryAddNumericFieldView(title: "Time Spent (Min)", iconName: "timer", text: $timeSpentMinutes)
                    }

                    WorkLogEntryAddSectionHeaderView(title: "Job Status & Details", iconName: "list.bullet.clipboard.fill")

                    VStack(spacing: 15) {
                        WorkLogEntryAddFieldView(title: "Status", iconName: "checkmark.circle.fill", text: $status)
                        WorkLogEntryAddNumericFieldView(title: "Step Number", iconName: "number", text: $stepNumber)
                        WorkLogEntryAddFieldView(title: "Work Note", iconName: "note.text", text: $note)
                        WorkLogEntryAddFieldView(title: "Remarks", iconName: "text.alignleft", text: $remarks)
                        WorkLogEntryAddToggleView(title: "Issue Resolved", iconName: "lightbulb.fill", isOn: $issueResolved)
                        WorkLogEntryAddFieldView(title: "Signature Name", iconName: "pencil.tip", text: $signatureName)
                    }

                    WorkLogEntryAddSectionHeaderView(title: "Readings & Environment", iconName: "gearshape.2.fill")

                    VStack(spacing: 15) {
                        HStack(spacing: 10) {
                            WorkLogEntryAddNumericFieldView(title: "Temp (°C)", iconName: "thermometer", text: $temperatureReading)
                                .frame(maxWidth: .infinity)
                            WorkLogEntryAddNumericFieldView(title: "Voltage (V)", iconName: "bolt.fill", text: $voltageReading)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)

                        HStack(spacing: 10) {
                            WorkLogEntryAddNumericFieldView(title: "Current (A)", iconName: "waveform.path.ecg", text: $currentReading)
                                .frame(maxWidth: .infinity)
                            WorkLogEntryAddNumericFieldView(title: "Resistance (Ω)", iconName: "ruler.fill", text: $resistanceReading)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        
                        WorkLogEntryAddNumericFieldView(title: "Humidity (%)", iconName: "drop.fill", text: $humidityLevel)
                        WorkLogEntryAddFieldView(title: "Environment Note", iconName: "house.fill", text: $environmentNote)
                    }
                    
                    WorkLogEntryAddSectionHeaderView(title: "Parts & Logistics", iconName: "wrench.and.screwdriver.fill")

                    VStack(spacing: 15) {
                        WorkLogEntryAddFieldView(title: "Component Replaced", iconName: "square.stack.3d.down.right.fill", text: $componentReplaced)
                        WorkLogEntryAddFieldView(title: "Part Used", iconName: "tag.fill", text: $partUsed)
                        WorkLogEntryAddFieldView(title: "Tools Used (Comma Separated)", iconName: "hammer.fill", text: $toolsUsed)
                        WorkLogEntryAddNumericFieldView(title: "Additional Cost ($)", iconName: "dollarsign.circle.fill", text: $additionalCost)
                        WorkLogEntryAddFieldView(title: "Image Name", iconName: "photo.fill", text: $imageName)
                        
                        WorkLogEntryAddToggleView(title: "Safety Check Done", iconName: "hand.raised.fill", isOn: $safetyCheckDone)
                        WorkLogEntryAddToggleView(title: "Cleaned After Service", iconName: "trash.fill", isOn: $cleanedAfterService)
                    }
                    
                    WorkLogEntryAddSectionHeaderView(title: "Customer & Warranty", iconName: "person.crop.circle.badge.checkmark")
                    
                    VStack(spacing: 15) {
                        WorkLogEntryAddNumericFieldView(title: "Satisfaction (1-5)", iconName: "heart.text.square.fill", text: $satisfactionLevel)
                        WorkLogEntryAddFieldView(title: "Customer Feedback", iconName: "text.bubble.fill", text: $customerFeedback)
                        WorkLogEntryAddToggleView(title: "Warranty Claim", iconName: "doc.text.fill", isOn: $warrantyClaim)
                        WorkLogEntryAddFieldView(title: "Claim Status", iconName: "list.bullet", text: $claimStatus)
                        
                        WorkLogEntryAddToggleView(title: "Next Visit Suggested", iconName: "calendar.badge.plus", isOn: $nextVisitSuggested)
                        if nextVisitSuggested {
                            WorkLogEntryAddDatePickerView(title: "Next Visit Date", iconName: "calendar", date: $nextVisitDate, component: .date)
                        }
                    }

                    Button(action: validateAndSave) {
                        Text("Save Complete Work Log")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue)
                                    .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK")) {
                                if newEntryID != nil {
                                }
                            }
                        )
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("New Work Log")
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryFieldBubble: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.caption2)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
    }
}
@available(iOS 14.0, *)
struct WorkLogEntryListRowView: View {
    let log: WorkLogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Header section
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(log.author)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(log.role) • Step \(log.stepNumber)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(log.status)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(log.issueResolved ? Color.green : Color.orange)
                    .cornerRadius(8)
            }
            
            Divider()
            
            // Technical readings section
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    WorkLogEntryFieldBubble(icon: "thermometer", label: "Temp", value: "\(String(format: "%.1f°C", log.temperatureReading))")
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "bolt.fill", label: "Volt", value: "\(String(format: "%.1fV", log.voltageReading))")
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "gauge", label: "Current", value: "\(String(format: "%.1fA", log.currentReading))")
                }
                
                HStack {
                    WorkLogEntryFieldBubble(icon: "waveform.path.ecg", label: "Resistance", value: "\(String(format: "%.1fΩ", log.resistanceReading))")
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "clock", label: "Time", value: "\(log.timeSpentMinutes) min")
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "drop.fill", label: "Humidity", value: "\(String(format: "%.1f%%", log.humidityLevel))")
                }
            }
            
            Divider()
            
            // Parts & Tools section
            VStack(alignment: .leading, spacing: 4) {
                Text("Part Used: \(log.partUsed)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text("Replaced: \(log.componentReplaced)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                if !log.toolsUsed.isEmpty {
                    Text("Tools: \(log.toolsUsed.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Supervisor & Service details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    WorkLogEntryFieldBubble(icon: "person.crop.circle", label: "Supervisor", value: log.supervisorName.isEmpty ? "N/A" : log.supervisorName)
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "dollarsign.circle.fill", label: "Cost", value: String(format: "$%.2f", log.additionalCost))
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "star.fill", label: "Rating", value: "\(log.satisfactionLevel)/5")
                }
                
                HStack {
                    WorkLogEntryFieldBubble(icon: "checkmark.shield.fill", label: "Safety", value: log.safetyCheckDone ? "Yes" : "No")
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "sparkles", label: "Cleaned", value: log.cleanedAfterService ? "Yes" : "No")
                    Spacer()
                    WorkLogEntryFieldBubble(icon: "calendar.badge.clock", label: "Next Visit", value: log.nextVisitSuggested ? formattedNextVisit : "No")
                }
            }
            
            Divider()
            
            // Warranty & Claim
            HStack {
                WorkLogEntryFieldBubble(icon: "doc.text.fill", label: "Warranty", value: log.warrantyClaim ? "Yes" : "No")
                Spacer()
                WorkLogEntryFieldBubble(icon: "hammer.fill", label: "Claim", value: log.claimStatus)
                Spacer()
                WorkLogEntryFieldBubble(icon: "clock.arrow.circlepath", label: "Updated", value: formattedDate(log.updatedAt))
            }
            
            Divider()
            
            // Notes & Remarks
            VStack(alignment: .leading, spacing: 4) {
                Text("Note: \(log.note.isEmpty ? "No note added." : log.note.prefix(80))\(log.note.count > 80 ? "..." : "")")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if !log.remarks.isEmpty {
                    Text("Remarks: \(log.remarks.prefix(80))\(log.remarks.count > 80 ? "..." : "")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if !log.environmentNote.isEmpty {
                    Text("Env: \(log.environmentNote.prefix(60))\(log.environmentNote.count > 60 ? "..." : "")")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Footer info
            HStack {
                Text("Created: \(formattedDate(log.createdAt))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Signature: \(log.signatureName.isEmpty ? "N/A" : log.signatureName)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
    
    private var formattedNextVisit: String {
        if let date = log.nextVisitDate {
            return formattedDate(date)
        }
        return "N/A"
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntrySearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.secondary)
            TextField("Search by Author, Part, or Status...", text: $searchText)
                .foregroundColor(.primary)

            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal)
        .animation(.easeInOut, value: searchText)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "list.bullet.clipboard.fill")
                .resizable()
                .frame(width: 60, height: 75)
                .foregroundColor(.secondary)
            
            Text("No Work Logs Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Create a new entry to track maintenance and repairs.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryListView: View {
    @ObservedObject var dataStore: MicrowaveDataStore
    @State private var showingAddView = false
    @State private var searchText: String = ""

    var filteredLogs: [WorkLogEntry] {
        if searchText.isEmpty {
            return dataStore.workLogs.reversed()
        } else {
            return dataStore.workLogs.reversed().filter { log in
                log.author.localizedCaseInsensitiveContains(searchText) ||
                log.partUsed.localizedCaseInsensitiveContains(searchText) ||
                log.status.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)

                VStack {
                    WorkLogEntrySearchBarView(searchText: $searchText)
                        .padding(.vertical, 5)

                    if filteredLogs.isEmpty {
                        WorkLogEntryNoDataView()
                    } else {
                        List {
                            ForEach(filteredLogs) { log in
                                NavigationLink(destination: WorkLogEntryDetailView(log: log)) {
                                    WorkLogEntryListRowView(log: log)
                                        .listRowInsets(EdgeInsets()) 
                                        .padding(.vertical, 5)
                                        .background(Color(UIColor.systemGroupedBackground))
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Work Logs")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddView) {
                WorkLogEntryAddView(dataStore: dataStore)
            }
        
    }

    private func deleteItems(offsets: IndexSet) {
        if let index = offsets.first {
            let logToDelete = filteredLogs[index]
            if let originalIndex = dataStore.workLogs.firstIndex(where: { $0.id == logToDelete.id }) {
                dataStore.workLogs.remove(at: originalIndex)
            }
        }
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryDetailFieldRow: View {
    let iconName: String
    let label: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 25, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(valueColor)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryDetailNoteBlock: View {
    let title: String
    let content: String
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.orange)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(content)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

@available(iOS 14.0, *)
struct WorkLogEntryDetailView: View {
    let log: WorkLogEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "hammer.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text(log.author)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Text("Role: \(log.role) | Step \(log.stepNumber)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack {
                        Image(systemName: log.issueResolved ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(.white)
                        Text(log.issueResolved ? "Issue Resolved" : "Awaiting Resolution")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                
                WorkLogEntryDetailNoteBlock(title: "Work Log Note", content: log.note, iconName: "note.text")
                
                VStack(alignment: .leading) {
                    Text("Technical Measurements")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    VStack(spacing: 1) {
                        HStack(alignment: .top) {
                            WorkLogEntryDetailFieldRow(iconName: "bolt.fill", label: "Voltage Reading", value: String(format: "%.1f V", log.voltageReading))
                                .frame(maxWidth: .infinity)
                            WorkLogEntryDetailFieldRow(iconName: "waveform.path.ecg", label: "Current Reading", value: String(format: "%.1f A", log.currentReading))
                                .frame(maxWidth: .infinity)
                        }
                        HStack(alignment: .top) {
                            WorkLogEntryDetailFieldRow(iconName: "ruler.fill", label: "Resistance Reading", value: String(format: "%.1f Ω", log.resistanceReading))
                                .frame(maxWidth: .infinity)
                            WorkLogEntryDetailFieldRow(iconName: "thermometer", label: "Temperature", value: String(format: "%.1f °C", log.temperatureReading))
                                .frame(maxWidth: .infinity)
                        }
                        HStack(alignment: .top) {
                            WorkLogEntryDetailFieldRow(iconName: "drop.fill", label: "Humidity Level", value: String(format: "%.1f %%", log.humidityLevel))
                                .frame(maxWidth: .infinity)
                            WorkLogEntryDetailFieldRow(iconName: "clock", label: "Time Spent", value: "\(log.timeSpentMinutes) min")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.white)
                
                VStack(alignment: .leading) {
                    Text("Parts & Inventory")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    VStack(spacing: 1) {
                        HStack(alignment: .top) {
                            WorkLogEntryDetailFieldRow(iconName: "gearshape.fill", label: "Component Replaced", value: log.componentReplaced)
                                .frame(maxWidth: .infinity)
                            WorkLogEntryDetailFieldRow(iconName: "tag.fill", label: "Part Used", value: log.partUsed)
                                .frame(maxWidth: .infinity)
                        }
                        HStack(alignment: .top) {
                            WorkLogEntryDetailFieldRow(iconName: "wrench.and.screwdriver.fill", label: "Tools Used", value: log.toolsUsed.joined(separator: ", "))
                                .frame(maxWidth: .infinity)
                            WorkLogEntryDetailFieldRow(iconName: "dollarsign.circle.fill", label: "Additional Cost", value: String(format: "$%.2f", log.additionalCost))
                                .frame(maxWidth: .infinity)
                        }
                        WorkLogEntryDetailFieldRow(iconName: "photo.fill", label: "Image Name", value: log.imageName.isEmpty ? "N/A" : log.imageName)
                    }
                    .padding(.horizontal)
                }
                .background(Color.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .foregroundColor(.pink)
                        Text("Customer & Quality Assurance")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 1) {
                        WorkLogEntryDetailFieldRow(iconName: "star.fill", label: "Satisfaction Level", value: "\(log.satisfactionLevel) / 5", valueColor: log.satisfactionLevel > 3 ? .green : .orange)
                        WorkLogEntryDetailFieldRow(iconName: "text.bubble.fill", label: "Customer Feedback", value: log.customerFeedback.isEmpty ? "No feedback" : log.customerFeedback)
                        
                        WorkLogEntryDetailFieldRow(iconName: "doc.text.fill", label: "Warranty Claim", value: log.warrantyClaim ? "YES" : "NO", valueColor: log.warrantyClaim ? .red : .green)
                        WorkLogEntryDetailFieldRow(iconName: "list.bullet", label: "Claim Status", value: log.claimStatus)
                        
                        WorkLogEntryDetailFieldRow(iconName: "eye.fill", label: "Supervisor", value: log.supervisorName.isEmpty ? "N/A" : log.supervisorName)
                        WorkLogEntryDetailFieldRow(iconName: "hand.raised.fill", label: "Safety Check Done", value: log.safetyCheckDone ? "Yes" : "No")
                        WorkLogEntryDetailFieldRow(iconName: "trash.fill", label: "Cleaned After Service", value: log.cleanedAfterService ? "Yes" : "No")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)

                WorkLogEntryDetailNoteBlock(title: "Environment/Logistics Note", content: log.environmentNote.isEmpty ? "N/A" : log.environmentNote, iconName: "map.fill")
                
                VStack(alignment: .leading) {
                    Text("Visit Scheduling")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    WorkLogEntryDetailFieldRow(iconName: "calendar.badge.plus", label: "Next Visit Suggested", value: log.nextVisitSuggested ? "YES" : "NO")
                    
                    if log.nextVisitSuggested {
                    }
                    
                    WorkLogEntryDetailFieldRow(iconName: "pencil.tip", label: "Technician Signature", value: log.signatureName)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
            }
        }
        .navigationTitle("Log Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
