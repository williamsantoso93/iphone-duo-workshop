import SwiftUI

/// Standard toolbar items move into a vertical bar on the outer display, with no extra code.
struct VerticalBarsDemo: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            content
        }
    }

    private var content: some View {
        List {
            Section {
                Text("Close, Done, and the bottom bar group are standard toolbar items, so iPhone Duo moves them into a vertical bar beside the camera on the outer display.")
            }
            Section("Messages") {
                ForEach(1...12, id: \.self) { index in
                    Label("Message \(index)", systemImage: "envelope")
                }
            }
        }
        .navigationTitle("Vertical Bars")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                DismissButton()
            }
            ToolbarItem(placement: .topBarPinnedTrailing) {
                Button("Done", systemImage: "checkmark") {
                    dismiss()
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Share", systemImage: "square.and.arrow.up") {}
                Button("Favorite", systemImage: "star") {}
                Button("Delete", systemImage: "trash", role: .destructive) {}
            }
        }
    }
}

#Preview {
    VerticalBarsDemo()
}
