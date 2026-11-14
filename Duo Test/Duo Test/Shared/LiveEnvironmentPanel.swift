import SwiftUI

/// Live readout of everything that changes as iPhone Duo opens, folds, rotates, and splits.
/// The host measures `size` and `insets` on its full-screen container, since this panel only sees its own frame.
struct LiveEnvironmentPanel: View {
    let size: CGSize
    let insets: EdgeInsets

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge

    @State private var hinge = HingeReading.unavailable

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: Metrics.spacing, verticalSpacing: Metrics.compactSpacing) {
            GridRow {
                Text("Size class")
                Text("H \(horizontalSizeClass.label) · V \(verticalSizeClass.label)")
            }
            GridRow {
                Text("Space")
                Text("\(Int(size.width)) × \(Int(size.height)) pt · \(size.width > size.height ? "wider than tall" : "taller than wide")")
            }
            GridRow {
                Text("Safe area")
                Text("T \(Int(insets.top)) · L \(Int(insets.leading)) · B \(Int(insets.bottom)) · R \(Int(insets.trailing))")
            }
            GridRow {
                Text("Vertical bar")
                Text(toolbarVerticalEdge.label)
            }
            GridRow {
                Text("Hinge")
                Label(hinge.label, systemImage: hinge.posture.systemImage)
            }
        }
        .font(.subheadline)
        .monospacedDigit()
        .foregroundStyle(.secondary)
        .contentTransition(.numericText())
        .onHingeChange { _, context in
            hinge = HingeReading(posture: Posture(context.hinge), angleDegrees: context.hinge?.angle.degrees)
        }
    }
}

private extension Optional where Wrapped == UserInterfaceSizeClass {
    var label: String {
        switch self {
        case .compact: "compact"
        case .regular: "regular"
        default: "unknown"
        }
    }
}

private extension Optional where Wrapped == HorizontalEdge {
    var label: String {
        switch self {
        case .leading: "leading edge"
        case .trailing: "trailing edge"
        default: "none"
        }
    }
}

private extension HingeReading {
    var label: String {
        guard let angleDegrees else { return posture.title }
        return "\(posture.title) · \(Int(angleDegrees.rounded()))°"
    }
}
