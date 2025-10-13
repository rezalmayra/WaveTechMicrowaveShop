import Combine
import Foundation
import SwiftUI


struct MicrowaveListing: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var sku: String
    var modelName: String
    var serialNumber: String
    var category: String
    var brand: String
    var wattage: Int
    var voltage: Int
    var capacityLiters: Int
    var color: String
    var dimensions: String
    var weightKg: Double
    var material: String
    var controlType: String
    var features: [String]
    var energyRating: String
    var warrantyYears: Int
    var manufactureDate: Date
    var purchaseDate: Date
    var supplier: String
    var costPrice: Double
    var sellingPrice: Double
    var stockQuantity: Int
    var locationBin: String
    var condition: String
    var notes: String
    var powerConsumption: Double
    var countryOfOrigin: String
    var barcode: String
    var maintenanceIntervalDays: Int
    var lastServicedDate: Date?
    var nextServiceDate: Date?
    var favorite: Bool
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
}

struct PartItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var partNumber: String
    var name: String
    var category: String
    var subCategory: String
    var manufacturer: String
    var modelCompatibility: String
    var description: String
    var material: String
    var color: String
    var size: String
    var weightGrams: Int
    var unitCost: Double
    var sellingPrice: Double
    var stockQuantity: Int
    var reorderThreshold: Int
    var reorderQuantity: Int
    var supplier: String
    var supplierContact: String
    var locationBin: String
    var storageCondition: String
    var warrantyMonths: Int
    var warrantyExpiry: Date?
    var purchaseDate: Date
    var lastRestocked: Date
    var barcode: String
    var notes: String
    var serialTracked: Bool
    var compatibleModels: [String]
    var partImageName: String
    var qualityGrade: String
    var rating: Int
    var active: Bool
    var createdAt: Date
    var updatedAt: Date
}

struct InventoryRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var partID: UUID
    var change: Int
    var reason: String
    var recordedBy: String
    var recordedAt: Date
    var approvalStatus: String
    var verifiedBy: String
    var verificationDate: Date?
    var previousQuantity: Int
    var newQuantity: Int
    var location: String
    var batchNumber: String
    var referenceDoc: String
    var costImpact: Double
    var remarks: String
    var transactionType: String
    var department: String
    var shift: String
    var temperature: Double
    var humidity: Double
    var barcode: String
    var supervisor: String
    var inspectionStatus: String
    var auditFlag: Bool
    var photoName: String
    var category: String
    var storageArea: String
    var shelfNumber: String
    var labelColor: String
    var recordSource: String
    var deviceName: String
    var sessionID: String
    var uploaded: Bool
    var createdAt: Date
    var updatedAt: Date
}

struct WorkLogEntry: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var jobID: UUID
    var author: String
    var role: String
    var note: String
    var timestamp: Date
    var stepNumber: Int
    var status: String
    var temperatureReading: Double
    var voltageReading: Double
    var currentReading: Double
    var resistanceReading: Double
    var componentReplaced: String
    var partUsed: String
    var timeSpentMinutes: Int
    var toolsUsed: [String]
    var imageName: String
    var customerFeedback: String
    var satisfactionLevel: Int
    var warrantyClaim: Bool
    var claimStatus: String
    var issueResolved: Bool
    var supervisorName: String
    var environmentNote: String
    var humidityLevel: Double
    var safetyCheckDone: Bool
    var cleanedAfterService: Bool
    var nextVisitSuggested: Bool
    var nextVisitDate: Date?
    var additionalCost: Double
    var remarks: String
    var signatureName: String
    var createdAt: Date
    var updatedAt: Date
}

struct MaintenanceTemplate: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var category: String
    var modelType: String
    var version: String
    var steps: [String]
    var recommendedIntervalDays: Int
    var estimatedDurationMinutes: Int
    var difficultyLevel: String
    var toolsRequired: [String]
    var safetyPrecautions: [String]
    var partsRequired: [String]
    var createdBy: String
    var approvedBy: String
    var approvalDate: Date?
    var reviewDate: Date?
    var rating: Int
    var usageCount: Int
    var lastUsedDate: Date?
    var nextReviewDate: Date?
    var remarks: String
    var tag: String
    var active: Bool
    var associatedModel: String
    var maintenanceType: String
    var department: String
    var versionNotes: String
    var language: String
    var country: String
    var estimatedCost: Double
    var warrantyRequired: Bool
    var lastUpdatedBy: String
    var createdAt: Date
    var updatedAt: Date
}

struct DiagnosticLog: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var details: String
    var recordedAt: Date
    var severity: String
    var technician: String
    var jobID: UUID?
    var deviceName: String
    var osVersion: String
    var appVersion: String
    var temperature: Double
    var voltage: Double
    var current: Double
    var resistance: Double
    var frequency: Double
    var notes: String
    var category: String
    var cause: String
    var solution: String
    var recommendation: String
    var timeSpentMinutes: Int
    var status: String
    var location: String
    var humidity: Double
    var testTools: [String]
    var imageName: String
    var videoName: String
    var tag: String
    var reviewedBy: String
    var reviewDate: Date?
    var approved: Bool
    var archived: Bool
    var createdAt: Date
    var updatedAt: Date
}
import Foundation
import Combine
import SwiftUI

@available(iOS 14.0, *)
class MicrowaveDataStore: ObservableObject {
    @Published var microwaves: [MicrowaveListing] = []
    @Published var parts: [PartItem] = []
    @Published var inventoryRecords: [InventoryRecord] = []
    @Published var workLogs: [WorkLogEntry] = []
    @Published var maintenanceTemplates: [MaintenanceTemplate] = []
    @Published var diagnosticLogs: [DiagnosticLog] = []

    private let microwaveKey = "microwave_listings"
    private let partKey = "part_items"
    private let inventoryKey = "inventory_records"
    private let workLogKey = "work_logs"
    private let maintenanceKey = "maintenance_templates"
    private let diagnosticKey = "diagnostic_logs"

    init() {
        loadAllData()
    }
    func addMicrowave(_ microwave: MicrowaveListing) {
        microwaves.append(microwave)
        saveData(microwaves, key: microwaveKey)
    }

    func addPart(_ part: PartItem) {
        parts.append(part)
        saveData(parts, key: partKey)
    }

    func addInventoryRecord(_ record: InventoryRecord) {
        inventoryRecords.append(record)
        saveData(inventoryRecords, key: inventoryKey)
    }

    func addWorkLog(_ log: WorkLogEntry) {
        workLogs.append(log)
        saveData(workLogs, key: workLogKey)
    }

    func addMaintenanceTemplate(_ template: MaintenanceTemplate) {
        maintenanceTemplates.append(template)
        saveData(maintenanceTemplates, key: maintenanceKey)
    }

    func addDiagnosticLog(_ log: DiagnosticLog) {
        diagnosticLogs.append(log)
        saveData(diagnosticLogs, key: diagnosticKey)
    }

    func deleteMicrowave(at offsets: IndexSet) {
        microwaves.remove(atOffsets: offsets)
        saveData(microwaves, key: microwaveKey)
    }

    func deletePart(at offsets: IndexSet) {
        parts.remove(atOffsets: offsets)
        saveData(parts, key: partKey)
    }

    func deleteInventoryRecord(at offsets: IndexSet) {
        inventoryRecords.remove(atOffsets: offsets)
        saveData(inventoryRecords, key: inventoryKey)
    }

    func deleteWorkLog(at offsets: IndexSet) {
        workLogs.remove(atOffsets: offsets)
        saveData(workLogs, key: workLogKey)
    }

    func deleteMaintenanceTemplate(at offsets: IndexSet) {
        maintenanceTemplates.remove(atOffsets: offsets)
        saveData(maintenanceTemplates, key: maintenanceKey)
    }

    func deleteDiagnosticLog(at offsets: IndexSet) {
        diagnosticLogs.remove(atOffsets: offsets)
        saveData(diagnosticLogs, key: diagnosticKey)
    }

    private func saveData<T: Codable>(_ data: [T], key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadData<T: Codable>(key: String, type: T.Type) -> [T] {
        guard let savedData = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([T].self, from: savedData)
        else { return [] }
        return decoded
    }

    private func loadAllData() {
        microwaves = loadData(key: microwaveKey, type: MicrowaveListing.self)
        parts = loadData(key: partKey, type: PartItem.self)
        inventoryRecords = loadData(key: inventoryKey, type: InventoryRecord.self)
        workLogs = loadData(key: workLogKey, type: WorkLogEntry.self)
        maintenanceTemplates = loadData(key: maintenanceKey, type: MaintenanceTemplate.self)
        diagnosticLogs = loadData(key: diagnosticKey, type: DiagnosticLog.self)

        if microwaves.isEmpty && parts.isEmpty {
            loadDummyData()
        }
    }

    func loadDummyData() {
        let now = Date()

        microwaves = [
            MicrowaveListing(
                sku: "MW-1001",
                modelName: "HeatMaster Pro",
                serialNumber: "SN12345",
                category: "Solo",
                brand: "HeatWave",
                wattage: 900,
                voltage: 220,
                capacityLiters: 20,
                color: "Silver",
                dimensions: "45x35x25 cm",
                weightKg: 12.5,
                material: "Stainless Steel",
                controlType: "Touch",
                features: ["Defrost", "Timer", "Child Lock"],
                energyRating: "A+",
                warrantyYears: 2,
                manufactureDate: now.addingTimeInterval(-86400 * 200),
                purchaseDate: now.addingTimeInterval(-86400 * 30),
                supplier: "ABC Electronics",
                costPrice: 120.0,
                sellingPrice: 199.0,
                stockQuantity: 10,
                locationBin: "A1",
                condition: "New",
                notes: "Bestseller",
                powerConsumption: 0.9,
                countryOfOrigin: "Japan",
                barcode: "MW1001-ABC",
                maintenanceIntervalDays: 180,
                lastServicedDate: now.addingTimeInterval(-86400 * 90),
                nextServiceDate: now.addingTimeInterval(86400 * 90),
                favorite: true,
                tags: ["Popular", "Energy Efficient"],
                createdAt: now,
                updatedAt: now
            )
        ]

        parts = [
            PartItem(
                partNumber: "PT-001",
                name: "Turntable Plate",
                category: "Replacement",
                subCategory: "Glass",
                manufacturer: "HeatWave",
                modelCompatibility: "HeatMaster Pro",
                description: "High quality microwave turntable plate.",
                material: "Tempered Glass",
                color: "Transparent",
                size: "27 cm",
                weightGrams: 500,
                unitCost: 5.0,
                sellingPrice: 9.9,
                stockQuantity: 50,
                reorderThreshold: 10,
                reorderQuantity: 30,
                supplier: "ABC Electronics",
                supplierContact: "support@abc.com",
                locationBin: "P1",
                storageCondition: "Room Temp",
                warrantyMonths: 6,
                warrantyExpiry: now.addingTimeInterval(86400 * 180),
                purchaseDate: now.addingTimeInterval(-86400 * 30),
                lastRestocked: now,
                barcode: "PT001-ABC",
                notes: "Fits multiple models",
                serialTracked: false,
                compatibleModels: ["HeatMaster Pro"],
                partImageName: "plate.png",
                qualityGrade: "A",
                rating: 5,
                active: true,
                createdAt: now,
                updatedAt: now
            )
        ]

        inventoryRecords = [
            InventoryRecord(
                partID: parts.first!.id,
                change: 5,
                reason: "Restock",
                recordedBy: "Admin",
                recordedAt: now,
                approvalStatus: "Approved",
                verifiedBy: "Manager",
                verificationDate: now,
                previousQuantity: 45,
                newQuantity: 50,
                location: "Warehouse A",
                batchNumber: "B001",
                referenceDoc: "INV123",
                costImpact: 25.0,
                remarks: "Restocked successfully",
                transactionType: "Inbound",
                department: "Inventory",
                shift: "Morning",
                temperature: 25.0,
                humidity: 40.0,
                barcode: "INV001",
                supervisor: "Mr. Ali",
                inspectionStatus: "Passed",
                auditFlag: true,
                photoName: "restock.jpg",
                category: "Parts",
                storageArea: "Main Shelf",
                shelfNumber: "S1",
                labelColor: "Blue",
                recordSource: "Manual",
                deviceName: "iPad",
                sessionID: "SID001",
                uploaded: true,
                createdAt: now,
                updatedAt: now
            )
        ]

        workLogs = [
            WorkLogEntry(
                jobID: UUID(),
                author: "Technician A",
                role: "Maintenance",
                note: "Replaced heating coil.",
                timestamp: now,
                stepNumber: 1,
                status: "Completed",
                temperatureReading: 80.0,
                voltageReading: 220.0,
                currentReading: 1.2,
                resistanceReading: 5.5,
                componentReplaced: "Coil",
                partUsed: "PT-001",
                timeSpentMinutes: 45,
                toolsUsed: ["Screwdriver", "Multimeter"],
                imageName: "repair.jpg",
                customerFeedback: "Good service",
                satisfactionLevel: 5,
                warrantyClaim: false,
                claimStatus: "N/A",
                issueResolved: true,
                supervisorName: "Mr. Khan",
                environmentNote: "Clean workspace",
                humidityLevel: 35.0,
                safetyCheckDone: true,
                cleanedAfterService: true,
                nextVisitSuggested: false,
                nextVisitDate: nil,
                additionalCost: 0.0,
                remarks: "Job completed",
                signatureName: "TechA",
                createdAt: now,
                updatedAt: now
            )
        ]

        maintenanceTemplates = [
            MaintenanceTemplate(
                name: "Basic Microwave Check",
                category: "Routine",
                modelType: "Solo",
                version: "1.0",
                steps: ["Inspect exterior", "Check power cord", "Run test cycle"],
                recommendedIntervalDays: 180,
                estimatedDurationMinutes: 30,
                difficultyLevel: "Easy",
                toolsRequired: ["Multimeter"],
                safetyPrecautions: ["Unplug before inspection"],
                partsRequired: ["PT-001"],
                createdBy: "Admin",
                approvedBy: "Supervisor",
                approvalDate: now,
                reviewDate: now,
                rating: 5,
                usageCount: 3,
                lastUsedDate: now,
                nextReviewDate: now.addingTimeInterval(86400 * 180),
                remarks: "Standard maintenance routine",
                tag: "Routine",
                active: true,
                associatedModel: "HeatMaster Pro",
                maintenanceType: "Preventive",
                department: "Service",
                versionNotes: "Initial release",
                language: "English",
                country: "Pakistan",
                estimatedCost: 50.0,
                warrantyRequired: false,
                lastUpdatedBy: "Admin",
                createdAt: now,
                updatedAt: now
            )
        ]

        diagnosticLogs = [
            DiagnosticLog(
                title: "Voltage Drop Detected",
                details: "Voltage dropped below 200V for 5 seconds.",
                recordedAt: now,
                severity: "Medium",
                technician: "Technician A",
                jobID: nil,
                deviceName: "iPad",
                osVersion: "iOS 14.0",
                appVersion: "1.0",
                temperature: 28.0,
                voltage: 198.0,
                current: 1.0,
                resistance: 4.8,
                frequency: 50.0,
                notes: "Power fluctuation issue.",
                category: "Electrical",
                cause: "Power supply instability",
                solution: "Recommend voltage stabilizer",
                recommendation: "Monitor usage for 1 week",
                timeSpentMinutes: 10,
                status: "Logged",
                location: "Workshop",
                humidity: 40.0,
                testTools: ["Multimeter"],
                imageName: "log.jpg",
                videoName: "video.mp4",
                tag: "Voltage",
                reviewedBy: "Supervisor",
                reviewDate: now,
                approved: true,
                archived: false,
                createdAt: now,
                updatedAt: now
            )
        ]

        saveData(microwaves, key: microwaveKey)
        saveData(parts, key: partKey)
        saveData(inventoryRecords, key: inventoryKey)
        saveData(workLogs, key: workLogKey)
        saveData(maintenanceTemplates, key: maintenanceKey)
        saveData(diagnosticLogs, key: diagnosticKey)
    }
}
