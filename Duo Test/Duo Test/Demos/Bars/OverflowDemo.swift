import SwiftUI

/// Eight toolbar items competing for a short vertical bar, with priority and compression choices.
struct OverflowDemo: View {
    @State private var compression = ToolbarVerticalCompressionBehavior.automatic

    var body: some View {
        TabView {
            Tab("Mail", systemImage: "envelope") {
                NavigationStack {
                    Form {
                        Picker("Compression", selection: $compression) {
                            Text("Automatic").tag(ToolbarVerticalCompressionBehavior.automatic)
                            Text("Prefer toolbar items").tag(ToolbarVerticalCompressionBehavior.prefersToolbarItems)
                            Text("Prefer tab bar").tag(ToolbarVerticalCompressionBehavior.prefersTabBar)
                        }
                        .pickerStyle(.inline)
                        Section {
                            Text("Rotate the outer display to landscape. Low-priority items overflow first; Compose has high priority and stays the longest.")
                        }
                    }
                    .navigationTitle("Overflow")
                    .toolbar { toolbarItems }
                }
            }
            Tab("Settings", systemImage: "gear") {
                NavigationStack {
                    ContentUnavailableView("Settings", systemImage: "gear")
                        .closeable()
                }
            }
        }
        .toolbarVerticalCompressionBehavior(compression)
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            DismissButton()
        }
        ToolbarItem(placement: .primaryAction) {
            Button("Compose", systemImage: "square.and.pencil") {}
        }
        .visibilityPriority(.high)
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button("Share", systemImage: "square.and.arrow.up") {}
            Button("Flag", systemImage: "flag") {}
            Button("Archive", systemImage: "archivebox") {}
            Button("Move", systemImage: "folder") {}
            Button("Pin", systemImage: "pin") {}
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button("Print", systemImage: "printer") {}
        }
        .visibilityPriority(.low)
        ToolbarOverflowMenu {
            Button("Scan", systemImage: "doc.viewfinder") {}
            Button("Connect", systemImage: "link") {}
        }
    }
}

#Preview {
    OverflowDemo()
}
