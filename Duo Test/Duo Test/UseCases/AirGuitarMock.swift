import SwiftUI

/// Fold the device to bend the strings, like a whammy bar. The bend follows the hinge 1:1.
struct AirGuitarMock: View {
    @State private var reading = HingeReading.unavailable

    private var bend: Double {
        reading.bend
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Metrics.spacing * 2) {
                Strings(bend: bend)
                    .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 260)
                    .accessibilityLabel("Guitar strings")
                    .accessibilityValue("Bent \(Int((bend * 100).rounded())) percent")
                if reading.posture == .unavailable {
                    ContentUnavailableView("No hinge on this device", systemImage: Posture.unavailable.systemImage,
                                           description: Text("Fold the device to bend the pitch."))
                } else {
                    HingeGauge(reading: reading)
                }
            }
            .padding(Metrics.spacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
            .navigationTitle("Air Guitar")
            .navigationBarTitleDisplayMode(.inline)
            .closeable()
            .onHingeChange { _, context in
                reading = HingeReading(posture: Posture(context.hinge), angleDegrees: context.hinge?.angle.degrees)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

/// Six strings; the bend pulls each one into a curve and warms its color.
private struct Strings: View {
    let bend: Double

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { index in
                BentString(bend: bend)
                    .stroke(Color.orange.mix(with: .pink, by: bend), lineWidth: 1.5 + Double(index) * 0.6)
                    .frame(maxHeight: .infinity)
            }
        }
    }
}

private struct BentString: Shape {
    var bend: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                          control: CGPoint(x: rect.midX, y: rect.midY - rect.height * 1.5 * bend))
        return path
    }
}

#Preview {
    AirGuitarMock()
}
