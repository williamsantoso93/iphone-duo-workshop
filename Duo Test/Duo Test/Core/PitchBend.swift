import Foundation

/// Turns the hinge angle into a normalized whammy-bar bend, as in the "Leverage multiple displays" tech talk.
enum PitchBend {
    /// 0 is no bend, 1 is the deepest bend. Only a partially open hinge bends;
    /// 180° is flat (no bend) and 90° or less is the deepest bend.
    static func normalized(angleDegrees: Double, posture: Posture) -> Double {
        guard posture == .partiallyOpen, angleDegrees.isFinite else { return 0 }
        return min(max((180 - angleDegrees) / 90, 0), 1)
    }
}
