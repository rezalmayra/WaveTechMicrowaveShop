


import SwiftUI
import Combine

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogAddSectionHeaderView: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogAddFieldView: View {
    let title: String
    let systemImage: String
    @Binding var text: String
    var isRequired: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title + (isRequired ? "*" : ""))
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(text.isEmpty ? 0 : 1)
                .animation(.easeOut(duration: 0.1), value: text.isEmpty)

            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
                    .frame(width: 20)

                TextField(title + (isRequired ? "*" : ""), text: $text)
                    .keyboardType(keyboardType)
                    .padding(.vertical, 8)
            }

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogAddDoubleFieldView: View {
    let title: String
    let systemImage: String
    @Binding var value: Double?
    var isRequired: Bool = false

    var body: some View {
        DiagnosticLogAddFieldView(
            title: title,
            systemImage: systemImage,
            text: Binding(
                get: { value.flatMap { String($0) } ?? "" },
                set: {
                    if let d = Double($0), $0 != "" {
                        value = d
                    } else if $0.isEmpty {
                        value = nil
                    }
                }
            ),
            isRequired: isRequired,
            keyboardType: .decimalPad
        )
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogAddIntFieldView: View {
    let title: String
    let systemImage: String
    @Binding var value: Int?
    var isRequired: Bool = false

    var body: some View {
        DiagnosticLogAddFieldView(
            title: title,
            systemImage: systemImage,
            text: Binding(
                get: { value.flatMap { String($0) } ?? "" },
                set: {
                    if let i = Int($0), $0 != "" {
                        value = i
                    } else if $0.isEmpty {
                        value = nil
                    }
                }
            ),
            isRequired: isRequired,
            keyboardType: .numberPad
        )
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogAddDatePickerView: View {
    let title: String
    let systemImage: String
    @Binding var date: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
            }
            .padding(.horizontal)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogAddToggleField: View {
    let title: String
    let systemImage: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(isOn ? .green : .red)
                    .frame(width: 20)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Spacer()

                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            .padding(.horizontal)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogSearchBarView: View {
    @Binding var searchText: String
    @State private var isSearching: Bool = false

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search logs...", text: $searchText, onEditingChanged: { editing in
                withAnimation(.easeIn) {
                    self.isSearching = editing
                }
            })
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    if isSearching && !searchText.isEmpty {
                        Spacer()
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .transition(.move(edge: .trailing))

            if isSearching {
                Button("Cancel") {
                    self.searchText = ""
                    UIApplication.shared.endEditing()
                    withAnimation(.easeOut) {
                        self.isSearching = false
                    }
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
        .animation(.easeOut, value: isSearching)
    }
}


@available(iOS 14.0, *)
fileprivate struct DiagnosticLogNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 80))
                .foregroundColor(.secondary)

            Text("No Diagnostic Logs Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("Your search returned no results. Try adjusting your filter or add a new log.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 50)
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogListRowView: View {
    let log: DiagnosticLog

    fileprivate struct MetricPill<T: CustomStringConvertible>: View {
        let icon: String
        let label: String
        let value: T
        var unit: String = ""
        let color: Color
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                
                Text("\(label):")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("\(value.description)\(unit)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(6)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: log.approved ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(log.approved ? .green : .orange)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(log.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Tech: \(log.technician) | Device: \(log.deviceName) | Loc: \(log.location.isEmpty ? "Unknown" : log.location)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(log.recordedAt, style: .date)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Text("\(log.timeSpentMinutes) min")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
            .padding(.bottom, 5)

            VStack(spacing: 8) {
                HStack {
                    MetricPill(icon: "thermometer", label: "Temp", value: log.temperature, unit: "°C", color: .red)
                    MetricPill(icon: "bolt.fill", label: "Voltage", value: log.voltage, unit: "V", color: .yellow)
                    MetricPill(icon: "lightbulb.fill", label: "Current", value: log.current, unit: "A", color: .orange)
                    MetricPill(icon: "tag.fill", label: "Category", value: log.category, color: .green)
                }
                HStack {
                    MetricPill(icon: "lifepreserver.fill", label: "Severity", value: log.severity, color: log.severity == "High" ? .red : .orange)
                    MetricPill(icon: "gyroscope", label: "Resistance", value: log.resistance, unit: "Ω", color: .purple)
                    MetricPill(icon: "cloud.fill", label: "Humidity", value: log.humidity, unit: "%", color: .blue)
                    MetricPill(icon: "lock.fill", label: "Approved", value: log.approved ? "Yes" : "No", color: log.approved ? .green : .gray)
                }
            }
            .padding(.horizontal, -15)

            Text("Cause: \(log.cause) | Solution: \(log.solution)")
                .font(.footnote)
                .foregroundColor(.gray)
                .lineLimit(1)
                .padding(.top, 5)
        }
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue.opacity(log.archived ? 0.2 : 0.6), lineWidth: log.archived ? 1 : 2)
        )
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogDetailSection: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.orange)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
fileprivate struct DiagnosticLogDetailMetricBadge: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

@available(iOS 14.0, *)
struct DiagnosticLogAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: MicrowaveDataStore

    @State private var title: String = ""
    @State private var details: String = ""
    @State private var recordedAt: Date = Date()
    @State private var severity: String = ""
    @State private var technician: String = ""
    @State private var jobID: String = ""
    @State private var deviceName: String = ""
    @State private var osVersion: String = ""
    @State private var appVersion: String = ""
    @State private var temperature: Double?
    @State private var voltage: Double?
    @State private var current: Double?
    @State private var resistance: Double?
    @State private var frequency: Double?
    @State private var notes: String = ""
    @State private var category: String = ""
    @State private var cause: String = ""
    @State private var solution: String = ""
    @State private var recommendation: String = ""
    @State private var timeSpentMinutes: Int?
    @State private var status: String = "Logged"
    @State private var location: String = ""
    @State private var humidity: Double?
    @State private var testTools: String = ""
    @State private var imageName: String = ""
    @State private var videoName: String = ""
    @State private var tag: String = ""
    @State private var reviewedBy: String = ""
    @State private var reviewDate: Date?
    @State private var approved: Bool = false
    @State private var archived: Bool = false
    @State private var createdAt: Date = Date()
    @State private var updatedAt: Date = Date()
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        let requiredFields: [(String, Bool)] = [
            ("Title", title.isEmpty),
            ("Details", details.isEmpty),
            ("Severity", severity.isEmpty),
            ("Technician", technician.isEmpty),
            ("Device Name", deviceName.isEmpty),
            ("Temperature", temperature == nil),
            ("Voltage", voltage == nil),
            ("Current", current == nil),
            ("Resistance", resistance == nil),
            ("Notes", notes.isEmpty),
            ("Category", category.isEmpty),
            ("Cause", cause.isEmpty),
            ("Solution", solution.isEmpty),
            ("Time Spent", timeSpentMinutes == nil)
        ]
        
        for (name, isMissing) in requiredFields {
            if isMissing {
                errors.append("\(name) is required.")
            }
        }
        
        if errors.isEmpty {
            saveLog()
            alertMessage = "Log saved successfully: **\(title)**"
        } else {
            alertMessage = "Please correct the following errors:\n\n" + errors.joined(separator: "\n")
        }
        
        showingAlert = true
    }

    private func saveLog() {
        let newLog = DiagnosticLog(
            title: title,
            details: details,
            recordedAt: recordedAt,
            severity: severity,
            technician: technician,
            jobID: UUID(uuidString: jobID) ?? nil,
            deviceName: deviceName,
            osVersion: osVersion,
            appVersion: appVersion,
            temperature: temperature ?? 0.0,
            voltage: voltage ?? 0.0,
            current: current ?? 0.0,
            resistance: resistance ?? 0.0,
            frequency: frequency ?? 0.0,
            notes: notes,
            category: category,
            cause: cause,
            solution: solution,
            recommendation: recommendation,
            timeSpentMinutes: timeSpentMinutes ?? 0,
            status: status,
            location: location,
            humidity: humidity ?? 0.0,
            testTools: testTools.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            imageName: imageName,
            videoName: videoName,
            tag: tag,
            reviewedBy: reviewedBy,
            reviewDate: approved ? Date() : nil,
            approved: approved,
            archived: archived,
            createdAt: Date(),
            updatedAt: Date()
        )
        dataStore.addDiagnosticLog(newLog)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DiagnosticLogAddSectionHeaderView(title: "Core Log Details", systemImage: "text.book.closed.fill")
                
                DiagnosticLogAddFieldView(title: "Title", systemImage: "pencil.circle.fill", text: $title, isRequired: true)
                DiagnosticLogAddFieldView(title: "Technician Name", systemImage: "person.fill", text: $technician, isRequired: true)
                
                HStack(spacing: 15) {
                    DiagnosticLogAddFieldView(title: "Device Name", systemImage: "microwave.fill", text: $deviceName, isRequired: true)
                    DiagnosticLogAddFieldView(title: "Location", systemImage: "mappin.and.ellipse", text: $location)
                }
                
                DiagnosticLogAddDatePickerView(title: "Recorded At", systemImage: "calendar", date: $recordedAt)
                
                DiagnosticLogAddSectionHeaderView(title: "Issue Classification", systemImage: "exclamationmark.octagon.fill")
                
                HStack(spacing: 15) {
                    DiagnosticLogAddFieldView(title: "Severity (e.g., High)", systemImage: "flame.fill", text: $severity, isRequired: true)
                    DiagnosticLogAddFieldView(title: "Category (e.g., Electrical)", systemImage: "tag.fill", text: $category, isRequired: true)
                }
                
                DiagnosticLogAddFieldView(title: "Cause", systemImage: "questionmark.circle.fill", text: $cause, isRequired: true)
                
                DiagnosticLogAddSectionHeaderView(title: "Technical Readings", systemImage: "waveform.path.ecg")
                
                HStack(spacing: 15) {
                    DiagnosticLogAddDoubleFieldView(title: "Temperature (°C)", systemImage: "thermometer", value: $temperature, isRequired: true)
                    DiagnosticLogAddDoubleFieldView(title: "Voltage (V)", systemImage: "bolt.fill", value: $voltage, isRequired: true)
                }
                
                HStack(spacing: 15) {
                    DiagnosticLogAddDoubleFieldView(title: "Current (A)", systemImage: "lightbulb.fill", value: $current, isRequired: true)
                    DiagnosticLogAddDoubleFieldView(title: "Resistance (Ω)", systemImage: "power", value: $resistance, isRequired: true)
                }

                HStack(spacing: 15) {
                    DiagnosticLogAddDoubleFieldView(title: "Frequency (Hz)", systemImage: "dot.radiowaves.right", value: $frequency)
                    DiagnosticLogAddDoubleFieldView(title: "Humidity (%)", systemImage: "cloud.fill", value: $humidity)
                }
                
                DiagnosticLogAddSectionHeaderView(title: "Action & Resolution", systemImage: "wrench.and.screwdriver.fill")
                
                DiagnosticLogAddIntFieldView(title: "Time Spent (Minutes)", systemImage: "clock.fill", value: $timeSpentMinutes, isRequired: true)
                
                DiagnosticLogAddFieldView(title: "Solution", systemImage: "wand.and.stars", text: $solution, isRequired: true)
                
                DiagnosticLogAddFieldView(title: "Recommendation", systemImage: "hand.thumbsup.fill", text: $recommendation)
                
                DiagnosticLogAddSectionHeaderView(title: "Extended Notes", systemImage: "note.text")

                DiagnosticLogAddFieldView(title: "Details/Description (Required)", systemImage: "list.bullet.clipboard.fill", text: $details, isRequired: true)
                
                DiagnosticLogAddFieldView(title: "Notes (Internal) (Required)", systemImage: "bubble.left.and.bubble.right.fill", text: $notes, isRequired: true)
                
                DiagnosticLogAddSectionHeaderView(title: "Administrative & Software", systemImage: "shield.lefthalf.fill")
                
                HStack(spacing: 15) {
                    DiagnosticLogAddFieldView(title: "OS Version", systemImage: "appletv.fill", text: $osVersion)
                    DiagnosticLogAddFieldView(title: "App Version", systemImage: "iphone.homebutton.badge.checkmark", text: $appVersion)
                }
                
                HStack(spacing: 15) {
                    DiagnosticLogAddFieldView(title: "Reviewed By", systemImage: "eyeglasses", text: $reviewedBy)
                    DiagnosticLogAddFieldView(title: "Test Tools (Comma separated)", systemImage: "briefcase.fill", text: $testTools)
                }

                HStack(spacing: 15) {
                    DiagnosticLogAddToggleField(title: "Approved", systemImage: "lock.open.fill", isOn: $approved)
                    DiagnosticLogAddToggleField(title: "Archived", systemImage: "archivebox.fill", isOn: $archived)
                }
                
                Button(action: validateAndSave) {
                    Text("Save Diagnostic Log")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)

            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationTitle("New Diagnostic Log")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(alertMessage.contains("successfully") ? "Success" : "Validation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("successfully") {
                    }
                }
            )
        }
    }
}

@available(iOS 14.0, *)
struct DiagnosticLogListView: View {
    @ObservedObject var dataStore: MicrowaveDataStore
    @State private var searchText: String = ""
    @State private var showingAddView: Bool = false

    var filteredLogs: [DiagnosticLog] {
        if searchText.isEmpty {
            return dataStore.diagnosticLogs.sorted(by: { $0.recordedAt > $1.recordedAt })
        } else {
            return dataStore.diagnosticLogs.filter { log in
                log.title.localizedCaseInsensitiveContains(searchText) ||
                log.technician.localizedCaseInsensitiveContains(searchText) ||
                log.cause.localizedCaseInsensitiveContains(searchText) ||
                log.category.localizedCaseInsensitiveContains(searchText) ||
                log.deviceName.localizedCaseInsensitiveContains(searchText)
            }.sorted(by: { $0.recordedAt > $1.recordedAt })
        }
    }
    
    private func deleteLogs(at offsets: IndexSet) {
        dataStore.deleteDiagnosticLog(at: offsets)
    }

    var body: some View {
            VStack(spacing: 0) {
                
                DiagnosticLogSearchBarView(searchText: $searchText)
                    .padding(.top, 5)

                if filteredLogs.isEmpty {
                    DiagnosticLogNoDataView()
                } else {
                    List {
                        ForEach(filteredLogs) { log in
                            ZStack {
                                NavigationLink(destination: DiagnosticLogDetailView(log: log)) {
                                    EmptyView()
                                }
                                .opacity(0)

                                DiagnosticLogListRowView(log: log)
                            }
                            .listRowInsets(EdgeInsets())
                            .background(Color(.systemGray6))
                        }
                        .onDelete(perform: deleteLogs)
                        .listRowBackground(Color(.systemGray6))
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Diagnostic Logs")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddView) {
                NavigationView {
                    DiagnosticLogAddView(dataStore: dataStore)
                }
            }
        
    }
}

@available(iOS 14.0, *)
struct DiagnosticLogDetailView: View {
    let log: DiagnosticLog
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(log.severity)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(log.severity == "High" ? Color.red.opacity(0.2) : Color.yellow.opacity(0.2))
                                .foregroundColor(log.severity == "High" ? .red : .yellow)
                                .cornerRadius(5)

                            Text(log.title)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                            
                            Text("Logged by **\(log.technician)** on \(dateFormatter.string(from: log.recordedAt))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "ladybug.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.pink)
                    }
                    .padding(.bottom, 10)
                    
                    Text(log.details)
                        .font(.body)
                        .italic()
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                
                VStack(alignment: .leading) {
                    DiagnosticLogDetailSection(title: "Key Metrics", systemImage: "gauge.high")
                    
                    HStack {
                        DiagnosticLogDetailMetricBadge(
                            title: "Voltage",
                            value: "\(String(format: "%.1f", log.voltage)) V",
                            icon: "bolt.fill",
                            color: .orange
                        )
                        DiagnosticLogDetailMetricBadge(
                            title: "Temperature",
                            value: "\(String(format: "%.1f", log.temperature)) °C",
                            icon: "thermometer.sun.fill",
                            color: .red
                        )
                        DiagnosticLogDetailMetricBadge(
                            title: "Time Spent",
                            value: "\(log.timeSpentMinutes) min",
                            icon: "clock.fill",
                            color: .purple
                        )
                    }
                }

                VStack(alignment: .leading) {
                    DiagnosticLogDetailSection(title: "Classification", systemImage: "folder.fill")
                    
                    VStack(spacing: 15) {
                        DiagnosticLogDetailFieldRow(label: "Category", value: log.category, icon: "tag.circle.fill", color: .green)
                        DiagnosticLogDetailFieldRow(label: "Cause", value: log.cause, icon: "exclamationmark.triangle.fill", color: .red)
                        DiagnosticLogDetailFieldRow(label: "Solution", value: log.solution, icon: "wrench.and.screwdriver.fill", color: .green)
                        DiagnosticLogDetailFieldRow(label: "Recommendation", value: log.recommendation.isEmpty ? "N/A" : log.recommendation, icon: "hand.thumbsup.fill", color: .yellow)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                }

                VStack(alignment: .leading) {
                    DiagnosticLogDetailSection(title: "Technical Data", systemImage: "server.rack.fill")

                    VStack(spacing: 15) {
                        HStack {
                            VStack(spacing: 15) {
                                DiagnosticLogDetailFieldRow(label: "Current", value: "\(String(format: "%.2f", log.current)) A", icon: "wave.3.left.circle.fill", color: .blue)
                                DiagnosticLogDetailFieldRow(label: "Resistance", value: "\(String(format: "%.2f", log.resistance)) Ω", icon: "line.diagonal", color: .red)
                                DiagnosticLogDetailFieldRow(label: "Frequency", value: "\(String(format: "%.1f", log.frequency)) Hz", icon: "dot.radiowaves.right", color: .orange)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 15) {
                                DiagnosticLogDetailFieldRow(label: "Humidity", value: "\(String(format: "%.1f", log.humidity)) %", icon: "cloud.fill", color: .yellow)
                                DiagnosticLogDetailFieldRow(label: "Location", value: log.location, icon: "mappin.and.ellipse", color: .red)
                                DiagnosticLogDetailFieldRow(label: "Device Name", value: log.deviceName, icon: "microwave.fill", color: .pink)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        DiagnosticLogDetailFieldRow(label: "Test Tools", value: log.testTools.joined(separator: ", ").isEmpty ? "None" : log.testTools.joined(separator: ", "), icon: "briefcase.fill", color: .pink)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    DiagnosticLogDetailSection(title: "Administration & Software", systemImage: "lock.shield.fill")

                    VStack(spacing: 15) {
                        HStack {
                            VStack(spacing: 15) {
                                DiagnosticLogDetailFieldRow(label: "Reviewed By", value: log.reviewedBy.isEmpty ? "Pending" : log.reviewedBy, icon: "eyeglasses", color: .gray)
                                DiagnosticLogDetailFieldRow(label: "Review Date", value: log.reviewDate.flatMap { dateFormatter.string(from: $0) } ?? "N/A", icon: "calendar.badge.clock", color: .gray)
                                DiagnosticLogDetailFieldRow(label: "OS Version", value: log.osVersion.isEmpty ? "N/A" : log.osVersion, icon: "laptopcomputer.and.arrow.down", color: .black)
                                DiagnosticLogDetailFieldRow(label: "App Version", value: log.appVersion.isEmpty ? "N/A" : log.appVersion, icon: "iphone.homebutton.badge.checkmark", color: .black)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 15) {
                                DiagnosticLogDetailFieldRow(label: "Approved", value: log.approved ? "Yes" : "No", icon: log.approved ? "hand.thumbsup.circle.fill" : "xmark.circle.fill", color: log.approved ? .green : .red)
                                DiagnosticLogDetailFieldRow(label: "Archived", value: log.archived ? "Yes" : "No", icon: log.archived ? "archivebox.fill" : "tray.fill", color: log.archived ? .gray : .blue)
                                DiagnosticLogDetailFieldRow(label: "Status", value: log.status, icon: "list.bullet.circle.fill", color: .orange)
                                DiagnosticLogDetailFieldRow(label: "Job ID", value: log.jobID?.uuidString ?? "N/A", icon: "barcode.viewfinder", color: .purple)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                }

                VStack(alignment: .leading) {
                    DiagnosticLogDetailSection(title: "Notes & Media", systemImage: "note.text.badge.plus")

                    VStack(alignment: .leading, spacing: 10) {
                        Text("**Internal Notes:**")
                            .font(.subheadline)
                        Text(log.notes)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Divider()
                        
                        Text("**Tags:** \(log.tag.isEmpty ? "None" : log.tag)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("**Media:** Image: \(log.imageName.isEmpty ? "None" : log.imageName) | Video: \(log.videoName.isEmpty ? "None" : log.videoName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }

            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationTitle(log.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
