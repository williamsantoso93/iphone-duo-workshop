import SwiftUI

/// Which toolbar items may move into the vertical bar, and which must stay horizontal.
struct AxisBehaviorDemo: View {
    @State private var isSelecting = false

    var body: some View {
        List {
            Section {
                row(".verticalPreferred", detail: "Compass is a custom view; it opts in and hides its text when vertical.")
                row(".horizontalOnly", detail: "The Select/Done text button needs width, so it stays in the horizontal bar.")
                row(".badge(7)", detail: "Use a badge instead of a count drawn inside the icon.")
                row("Edit", detail: "A text-only item for comparison: it stays horizontal.")
            }
        }
        .navigationTitle("Axis Behavior")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CompassView()
            }
            .axisBehavior(.verticalPreferred)
            ToolbarItem(placement: .topBarTrailing) {
                Button(isSelecting ? "Done" : "Select") {
                    isSelecting.toggle()
                }
            }
            .axisBehavior(.horizontalOnly)
            ToolbarItem(placement: .bottomBar) {
                Button("Inbox", systemImage: "tray") {}
                    .badge(7)
            }
            ToolbarItem(placement: .bottomBar) {
                Button("Edit") {}
            }
        }
    }

    private func row(_ symbol: String, detail: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: symbol)
                .font(.callout.weight(.semibold))
                .fontDesign(.monospaced)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        AxisBehaviorDemo()
    }
}
