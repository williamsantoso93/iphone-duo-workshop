import CoreGraphics

/// Chooses a grid column count that divides cleanly around the fold.
enum GridPolicy {
    /// Always at least one column. When the device can fold, an odd count above one drops to the
    /// next even number so no item straddles the hinge (HIG: prefer an even number of columns).
    static func columns(width: CGFloat, minItemWidth: CGFloat, hasDivision: Bool) -> Int {
        guard minItemWidth > 0, width.isFinite else { return 1 }
        let count = max(1, Int(width / minItemWidth))
        if hasDivision, count > 1, count.isMultiple(of: 2) == false {
            return count - 1
        }
        return count
    }
}
