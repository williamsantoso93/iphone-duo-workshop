import SwiftUI

/// A device pose a use case is designed for.
struct PoseChip: View {
    let posture: Posture

    var body: some View {
        Label(posture.title, systemImage: posture.systemImage)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.tint.quaternary, in: .capsule)
    }
}

/// A use case's poses in a row, stacking vertically when a row won't fit (large Dynamic Type).
struct PoseChipRow: View {
    let poses: [Posture]

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: Metrics.compactSpacing) { chips }
            VStack(alignment: .leading, spacing: Metrics.compactSpacing) { chips }
        }
    }

    private var chips: some View {
        ForEach(poses, id: \.self) { posture in
            PoseChip(posture: posture)
        }
    }
}
