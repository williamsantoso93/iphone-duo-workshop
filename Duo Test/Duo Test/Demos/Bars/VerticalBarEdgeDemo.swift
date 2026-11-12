import SwiftUI

/// Reads which edge the vertical bar is on, so content and extended backgrounds can respond.
struct VerticalBarEdgeDemo: View {
    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge

    private var edgeTitle: LocalizedStringKey {
        switch toolbarVerticalEdge {
        case .leading: "Leading"
        case .trailing: "Trailing"
        default: "No vertical bar"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacing) {
                LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 200)
                    .overlay {
                        Text(edgeTitle)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .contentTransition(.opacity)
                    }
                    .backgroundExtensionEffect()

                Text("The hero image extends under the vertical bar with backgroundExtensionEffect(), while its text stays clear of it.")
                    .padding(.horizontal, Metrics.spacing)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle("Vertical Bar Edge")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Share", systemImage: "square.and.arrow.up") {}
                Button("Favorite", systemImage: "star") {}
            }
        }
    }
}

#Preview {
    NavigationStack {
        VerticalBarEdgeDemo()
    }
}
