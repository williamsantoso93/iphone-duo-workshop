import SwiftUI

/// A custom toolbar view that opts into the vertical bar and drops its text when it lands there.
struct CompassView: View {
    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.north.line.fill")
            if toolbarVerticalEdge == nil {
                Text("N 12°")
                    .monospacedDigit()
            }
        }
        .font(.subheadline.weight(.semibold))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Heading north, 12 degrees")
    }
}
