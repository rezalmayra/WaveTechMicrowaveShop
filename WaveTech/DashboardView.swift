import SwiftUI
import Combine



@available(iOS 14.0, *)
struct DashboardNavigationRow<Destination: View>: View {
    var title: String
    var subtitle: String
    var icon: String
    var iconColor: Color
    var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 15) {
                // Icon Container
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .background(iconColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color.secondary.opacity(0.5))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@available(iOS 14.0, *)
struct LargeStatsCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Text(value)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
            
            Text("Total Microwaves in Inventory")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}



@available(iOS 14.0, *)
struct MicrowaveWorkshopProView: View {
    @StateObject private var dataStore = MicrowaveDataStore()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Microwave Workshop")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Core Modules")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.leading)

                        VStack(spacing: 0) {
                            DashboardNavigationRow(
                                title: "Microwave Listings",
                                subtitle: "All models and specs",
                                icon: "microwave.fill",
                                iconColor: .orange,
                                destination: { MicrowaveListingListView(dataStore: dataStore) }
                            )
                            
                            Divider().padding(.leading, 60)
                            
                            DashboardNavigationRow(
                                title: "Parts Inventory",
                                subtitle: "View spare parts & stock levels",
                                icon: "cube.box.fill",
                                iconColor: .blue,
                                destination: { PartItemListView(dataStore: dataStore) }
                            )
                            
                            Divider().padding(.leading, 60)

                            DashboardNavigationRow(
                                title: "Inventory Records",
                                subtitle: "Movement history (In/Out)",
                                icon: "tray.full.fill",
                                iconColor: .green,
                                destination: { InventoryListView(dataStore: dataStore) }
                            )
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
                    }

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Operational Logs")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.leading)

                        VStack(spacing: 0) {
                            DashboardNavigationRow(
                                title: "Work Logs",
                                subtitle: "Technician job and repair history",
                                icon: "wrench.and.screwdriver.fill",
                                iconColor: .purple,
                                destination: { WorkLogEntryListView(dataStore: dataStore) }
                            )
                            
                            Divider().padding(.leading, 60)

                            DashboardNavigationRow(
                                title: "Maintenance Templates",
                                subtitle: "Standardized service procedures",
                                icon: "doc.text.fill",
                                iconColor: .pink,
                                destination: { MaintenanceTemplateListView(dataStore: dataStore) }
                            )
                            
                            Divider().padding(.leading, 60)

                            DashboardNavigationRow(
                                title: "Diagnostic Logs",
                                subtitle: "Device failure and error reports",
                                icon: "waveform.path.ecg.rectangle.fill",
                                iconColor: .red,
                                destination: { DiagnosticLogListView(dataStore: dataStore) }
                            )
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
