import CoreGraphics

/// The usable regions of a container once an active fold divides it.
enum FoldPanes: Equatable {
    case single(CGRect)
    case sideBySide(leading: CGRect, trailing: CGRect)
    case stacked(top: CGRect, bottom: CGRect)
}
