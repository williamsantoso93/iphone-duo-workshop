import SwiftUI

/// A floating gauge for one hinge reading: a 0–180° arc, the posture, and the pitch bend it would drive.
/// The angle follows the hinge 1:1, so nothing here adds its own animation.
struct HingeGauge: View {
    let reading: HingeReading

    private var bend: Double {
        reading.bend
    }

    private var bendMaxed: Bool {
        bend >= 1
    }

    var body: some View {
        VStack(spacing: Metrics.spacing) {
            ZStack(alignment: .bottom) {
                HalfArc(fraction: 1)
                    .stroke(.quaternary, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                HalfArc(fraction: (reading.angleDegrees ?? 0) / 180)
                    .stroke(Color.accentColor.gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                VStack(spacing: 4) {
                    Image(systemName: reading.posture.systemImage)
                        .font(.title2)
                        .symbolEffect(.bounce, value: reading.posture)
                    angleText
                        .font(.largeTitle.bold())
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }
            }
            .frame(width: 200, height: 112)

            Text(reading.posture.title)
                .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
                LabeledContent("Pitch bend", value: bend, format: .percent.precision(.fractionLength(0)))
                    .font(.subheadline)
                    .monospacedDigit()
                ProgressView(value: bend)
            }
            .frame(maxWidth: 260)
        }
        .padding(Metrics.spacing)
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.cardRadius))
        .sensoryFeedback(.selection, trigger: reading.posture)
        .sensoryFeedback(.impact(weight: .light), trigger: bendMaxed) { _, isMaxed in isMaxed }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var angleText: some View {
        if let degrees = reading.angleDegrees {
            Text("\(degrees, format: .number.precision(.fractionLength(0)))°")
        } else {
            Text("—")
        }
    }
}

/// The upper half of a circle, drawn from the leading end; `fraction` 1 is the full 180°.
private struct HalfArc: Shape {
    var fraction: Double

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width / 2, rect.height) - 6
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let clamped = min(max(fraction, 0), 1)
        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: .degrees(180),
                    endAngle: .degrees(180 + 180 * clamped), clockwise: false)
        return path
    }
}

#Preview {
    HingeGauge(reading: HingeReading(posture: .partiallyOpen, angleDegrees: 120))
        .padding()
}
