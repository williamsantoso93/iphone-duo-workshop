import Foundation

/// A snapshot of the hinge: its discrete posture plus the continuous angle when one is reported.
struct HingeReading: Equatable, Sendable {
    var posture: Posture
    /// Always finite and within 0…180, so it can be formatted or drawn without checks.
    var angleDegrees: Double?

    init(posture: Posture, angleDegrees: Double?) {
        self.posture = posture
        self.angleDegrees = angleDegrees.flatMap { $0.isFinite ? min(max($0, 0), 180) : nil }
    }

    /// How far the strings bend, 0…1.
    var bend: Double {
        angleDegrees.map { PitchBend.normalized(angleDegrees: $0, posture: posture) } ?? 0
    }

    static let unavailable = HingeReading(posture: .unavailable, angleDegrees: nil)
}
