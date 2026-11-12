import SwiftUI

enum ArrangementDemoStyle: CaseIterable {
    case split, splitHorizontalOnly, overlay

    var title: LocalizedStringKey {
        switch self {
        case .split: "Split"
        case .splitHorizontalOnly: "Split, horizontal only"
        case .overlay: "Overlay"
        }
    }

    var systemImage: String {
        switch self {
        case .split: "rectangle.split.2x1"
        case .splitHorizontalOnly: "rectangle.split.2x1.slash"
        case .overlay: "square.on.square"
        }
    }
}

/// Player plus Up Next in an `ArrangementView`. The navigation stack sits outside the arrangement
/// (it comes from `DemoLauncher`), as Apple recommends.
struct ArrangementDemo: View {
    @State private var style: ArrangementDemoStyle
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(initialStyle: ArrangementDemoStyle) {
        self.style = initialStyle
    }

    var body: some View {
        ArrangementView {
            PlayerMock()
        } secondary: {
            UpNextMock()
        }
        .arrangementViewStyle(DemoArrangementStyle(style: style))
        .animation(Motion.resolve(Motion.standard, reduceMotion: reduceMotion), value: style)
        .navigationTitle("Arrangement")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu("Options", systemImage: style.systemImage) {
                    Picker("Arrangement", selection: $style) {
                        ForEach(ArrangementDemoStyle.allCases, id: \.self) { style in
                            Label(style.title, systemImage: style.systemImage)
                        }
                    }
                }
            }
        }
    }
}

/// Picks the system arrangement style at run time, so switching styles keeps the player's identity and state.
private struct DemoArrangementStyle: ArrangementViewStyle {
    let style: ArrangementDemoStyle

    func makeBody(configuration: Configuration) -> some View {
        switch style {
        case .split:
            ArrangementView(configuration)
                .arrangementViewStyle(.split)
        case .splitHorizontalOnly:
            // Where a horizontal split doesn't fit (inner display in portrait), only the primary shows.
            ArrangementView(configuration)
                .arrangementViewStyle(.split.axes(.horizontal))
        case .overlay:
            ArrangementView(configuration)
                .arrangementViewStyle(.overlay)
        }
    }
}

#Preview {
    NavigationStack {
        ArrangementDemo(initialStyle: .overlay)
    }
}
