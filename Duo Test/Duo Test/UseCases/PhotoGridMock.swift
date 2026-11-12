import SwiftUI

/// A photo grid with an even column count when the device can fold. When the fold is active and runs
/// like a book, the grid splits into one grid per pane and the gap at the hinge widens by the fold's width.
struct PhotoGridMock: View {
    private let minItemWidth: CGFloat = 110
    private let gap: CGFloat = 4

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let hasDivision = !proxy.reservedRegions(kind: .division, options: .includeInactive).isEmpty
                let division = proxy.reservedRegions(kind: .division).first(where: \.isActive)?.frame
                ScrollView {
                    switch FoldSplit.panes(container: proxy.size, division: division) {
                    case .sideBySide(let leading, let trailing):
                        // Each grid fills its own pane, inset by the spacing, so the gap lands on the hinge
                        // even when the panes differ in width (asymmetric safe areas).
                        let leadingWidth = leading.width - Metrics.spacing * 2
                        let trailingWidth = trailing.width - Metrics.spacing * 2
                        let half = MockData.photos.count / 2
                        HStack(alignment: .top, spacing: trailing.minX - leading.maxX + Metrics.spacing * 2) {
                            grid(Array(MockData.photos[..<half]),
                                 columns: GridPolicy.columns(width: leadingWidth, minItemWidth: minItemWidth, hasDivision: false))
                                .frame(width: max(leadingWidth, 0))
                            grid(Array(MockData.photos[half...]),
                                 columns: GridPolicy.columns(width: trailingWidth, minItemWidth: minItemWidth, hasDivision: false))
                                .frame(width: max(trailingWidth, 0))
                        }
                        .padding(.leading, leading.minX + Metrics.spacing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    case .single, .stacked:
                        let width = proxy.size.width - Metrics.spacing * 2
                        grid(MockData.photos, columns: GridPolicy.columns(width: width, minItemWidth: minItemWidth,
                                                                          hasDivision: hasDivision))
                            .padding(.horizontal, Metrics.spacing)
                    }
                }
            }
            .navigationTitle("Photos")
            .closeable()
        }
    }

    private func grid(_ photos: [MockData.Photo], columns: Int) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gap), count: columns), spacing: gap) {
            ForEach(photos) { photo in
                PhotoTile(photo: photo)
                    .contextMenu {
                        Button("Share", systemImage: "square.and.arrow.up") {}
                        Button("Favorite", systemImage: "heart") {}
                        Button("Delete", systemImage: "trash", role: .destructive) {}
                    }
            }
        }
    }
}

private struct PhotoTile: View {
    let photo: MockData.Photo

    var body: some View {
        Rectangle()
            .fill(LinearGradient(colors: [Color(hue: photo.hue, saturation: 0.55, brightness: 0.95),
                                          Color(hue: photo.hue, saturation: 0.8, brightness: 0.6)],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Image(systemName: photo.systemImage)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .clipShape(.rect(cornerRadius: 4))
            .accessibilityLabel("Photo \(photo.id + 1)")
    }
}

#Preview {
    PhotoGridMock()
}
