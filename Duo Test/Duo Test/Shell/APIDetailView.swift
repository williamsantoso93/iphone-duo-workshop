import SwiftUI

/// One API: what it is, its spellings, the live environment, and the demo itself.
struct APIDetailView: View {
    let entry: APIEntry

    @State private var size: CGSize = .zero
    @State private var insets = EdgeInsets()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacing * 1.5) {
                APIHeader(entry: entry)

                Card {
                    DisclosureGroup {
                        LiveEnvironmentPanel(size: size, insets: insets)
                            .padding(.top, Metrics.compactSpacing)
                    } label: {
                        Label("Live environment", systemImage: "gauge.with.dots.needle.33percent")
                            .font(.headline)
                    }
                }

                APIDemoRouter(entry: entry)
            }
            .padding(Metrics.spacing)
        }
        .onGeometryChange(for: CGSize.self, of: \.size) { size = $1 }
        .onGeometryChange(for: EdgeInsets.self, of: \.safeAreaInsets) { insets = $1 }
        .navigationTitle(entry.title)
        .toolbar {
            ToolbarItem(placement: .topBarPinnedTrailing) {
                ShareLink(item: entry.talk.url) {
                    Label("Share talk", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}
