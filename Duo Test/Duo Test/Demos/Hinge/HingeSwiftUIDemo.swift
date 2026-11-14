import SwiftUI

/// Reads the hinge with `onHingeChange`; a `nil` hinge means the device has none.
struct HingeSwiftUIDemo: View {
    @State private var reading = HingeReading.unavailable

    var body: some View {
        VStack(spacing: Metrics.spacing) {
            if reading.posture == .unavailable {
                ContentUnavailableView("No hinge on this device", systemImage: Posture.unavailable.systemImage)
            } else {
                HingeGauge(reading: reading)
            }
            Text("For layout, use arrangements and reserved regions — hinge is for interactions and effects.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .onHingeChange { _, context in
            reading = HingeReading(posture: Posture(context.hinge), angleDegrees: context.hinge?.angle.degrees)
        }
    }
}

#Preview {
    HingeSwiftUIDemo()
        .padding()
}
