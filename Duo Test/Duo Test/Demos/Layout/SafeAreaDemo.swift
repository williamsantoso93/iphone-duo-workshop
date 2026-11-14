import SwiftUI

/// Background runs edge to edge; interactive content stays inside safe areas that differ per edge.
struct SafeAreaDemo: View {
    @State private var insets = EdgeInsets()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Rectangle()
                .strokeBorder(.white.opacity(0.8), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))

            VStack(alignment: .leading, spacing: Metrics.spacing) {
                Text("Safe area")
                    .font(.title2.bold())
                Text(insets.leading == insets.trailing ? "Leading = trailing" : "Leading ≠ trailing")
                    .font(.headline)
                    .foregroundStyle(insets.leading == insets.trailing ? Color.secondary : Color.orange)
                    .contentTransition(.opacity)
                Divider()
                Label {
                    Text(verbatim: "width - safeAreaInsets.left * 2")
                } icon: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
                Label {
                    Text(verbatim: "bounds.inset(by: safeAreaInsets)")
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            .font(.callout)
            .fontDesign(.monospaced)
            .padding(Metrics.spacing)
            .frame(maxWidth: 360)
            .background(.regularMaterial, in: .rect(cornerRadius: Metrics.cardRadius))
            .padding(Metrics.spacing)
        }
        .overlay(alignment: .top) { inset("Top", insets.top) }
        .overlay(alignment: .bottom) { inset("Bottom", insets.bottom) }
        .overlay(alignment: .leading) { inset("Leading", insets.leading) }
        .overlay(alignment: .trailing) { inset("Trailing", insets.trailing) }
        .onGeometryChange(for: EdgeInsets.self, of: \.safeAreaInsets) { insets = $1 }
        .floatingCloseButton()
    }

    private func inset(_ edge: LocalizedStringKey, _ value: CGFloat) -> some View {
        Text("\(Text(edge)) \(Int(value))")
            .font(.caption.weight(.semibold))
            .monospacedDigit()
            .contentTransition(.numericText())
            .padding(.horizontal, Metrics.compactSpacing)
            .padding(.vertical, 4)
            .glassEffect(.regular, in: .capsule)
            .padding(6)
    }
}

#Preview {
    SafeAreaDemo()
}
