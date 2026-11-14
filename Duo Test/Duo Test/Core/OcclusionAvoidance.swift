import CoreGraphics

/// Keeps a custom bar clear of occlusion regions such as the inner front camera.
enum OcclusionAvoidance {
    /// The top padding that moves `barFrame` below every occlusion that overlaps it.
    static func topInset(barFrame: CGRect, occlusions: [CGRect]) -> CGFloat {
        occlusions
            .filter { $0.intersects(barFrame) }
            .map(\.maxY)
            .max() ?? 0
    }
}
