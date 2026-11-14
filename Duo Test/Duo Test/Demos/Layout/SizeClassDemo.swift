import SwiftUI

/// Lays out by width class and aspect, never by device or pose.
struct SizeClassDemo: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var size: CGSize = .zero

    private var isRegular: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.spacing) {
            let layout = isRegular
                ? AnyLayout(HStackLayout(spacing: Metrics.compactSpacing))
                : AnyLayout(VStackLayout(spacing: Metrics.compactSpacing))

            layout {
                pane("List", systemImage: "list.bullet", color: .blue)
                pane("Detail", systemImage: "doc.text", color: .indigo)
                pane("Inspector", systemImage: "slider.horizontal.3", color: .purple)
            }
            .frame(height: isRegular ? 120 : 260)
            .onGeometryChange(for: CGSize.self, of: \.size) { size = $1 }
            .animation(Motion.resolve(Motion.standard, reduceMotion: reduceMotion), value: isRegular)

            Label(
                isRegular ? "Regular width → HStack" : "Compact width → VStack",
                systemImage: isRegular ? "rectangle.split.3x1" : "rectangle.split.1x2"
            )
            .font(.headline)
            .contentTransition(.symbolEffect(.replace))

            Text("\(Int(size.width)) × \(Int(size.height)) pt · \(size.width > size.height ? "wider than tall" : "taller than wide")")
                .font(.subheadline)
                .monospacedDigit()
                .foregroundStyle(.secondary)

            Card {
                Grid(alignment: .leading, horizontalSpacing: Metrics.spacing, verticalSpacing: Metrics.compactSpacing) {
                    GridRow {
                        Text("Pose")
                        Text("Width")
                        Text("Height")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    Divider()
                    sizeRow("Outer, portrait", width: "Compact", height: "Regular")
                    sizeRow("Outer, landscape", width: "Compact", height: "Compact")
                    sizeRow("Inner, any", width: "Regular", height: "Regular")
                }
                .font(.subheadline)
            }
        }
    }

    private func pane(_ title: LocalizedStringKey, systemImage: String, color: Color) -> some View {
        Label(title, systemImage: systemImage)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color.gradient, in: .rect(cornerRadius: Metrics.cardRadius - 6))
    }

    private func sizeRow(_ pose: LocalizedStringKey, width: LocalizedStringKey, height: LocalizedStringKey) -> some View {
        GridRow {
            Text(pose)
            Text(width)
            Text(height)
        }
    }
}

#Preview {
    SizeClassDemo()
        .padding()
}
