import SwiftUI

/// The secondary view of an arrangement. In an overlay arrangement it collapses to a pill while it sits
/// on top of the player (`overlayArrangementZIndex > 0`), and expands into a full list once split beside it.
struct UpNextMock: View {
    @Environment(\.overlayArrangementZIndex) private var environmentZIndex

    private var isCollapsed: Bool {
        environmentZIndex > 0
    }

    var body: some View {
        if isCollapsed {
            Label("Up Next · 8 episodes", systemImage: "list.bullet")
                .font(.headline)
                .padding(.horizontal, Metrics.spacing)
                .padding(.vertical, 12)
                .glassEffect(.regular.interactive(), in: .capsule)
                .padding(Metrics.spacing)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        } else {
            List {
                Section("Up Next") {
                    ForEach(43...50, id: \.self) { number in
                        VStack(alignment: .leading) {
                            Text("Episode \(number)")
                                .font(.headline)
                            Text("\(20 + number % 7 * 5) min")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UpNextMock()
}
