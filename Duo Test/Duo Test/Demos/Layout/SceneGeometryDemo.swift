import SwiftUI

/// SwiftUI reads size from the view's own geometry and scale from the environment, never from a screen.
/// Both update on every layout pass, so a fold or a window resize mid-session shows up right away.
struct SceneGeometryDemo: View {
    @Environment(\.displayScale) private var displayScale

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
                Text("container  \(Int(proxy.size.width)) × \(Int(proxy.size.height))")
                Text("displayScale  \(displayScale, specifier: "%.0f")×")
            }
            .font(.callout.monospaced())
            .padding(Metrics.spacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentTransition(.numericText())
        }
        .frame(minHeight: 140)
        .background(.background.secondary, in: .rect(cornerRadius: Metrics.cardRadius))
    }
}

#Preview {
    SceneGeometryDemo()
        .padding()
}
