import SwiftUI

/// Opens a second window. Only the inner display can create windows, so the button disables itself
/// in a compact width.
struct MultiWindowDemo: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The API the new window shows on its own.
    private let entryID = "hingeSwiftUI"

    private var canOpenWindow: Bool {
        horizontalSizeClass != .compact
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.spacing) {
            VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
                Button("Open Hinge in a new window", systemImage: "macwindow.badge.plus") {
                    openWindow(id: "detail", value: entryID)
                }
                .buttonStyle(.glassProminent)
                .disabled(!canOpenWindow)
                if !canOpenWindow {
                    Text("New windows can only be created on the inner display")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MultiWindowDemo()
        .padding()
}
