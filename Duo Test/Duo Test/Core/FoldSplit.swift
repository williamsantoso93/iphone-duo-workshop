import CoreGraphics

/// Splits a container around a division reserved region (the fold), keeping content out of the division itself.
enum FoldSplit {
    static func panes(container: CGSize, division: CGRect?) -> FoldPanes {
        let bounds = CGRect(origin: .zero, size: container)
        // An inactive fold has zero width, so treat any degenerate or out-of-bounds division as no fold.
        guard let division, division.width > 0, division.height > 0, bounds.intersects(division) else {
            return .single(bounds)
        }

        if division.height > division.width {
            // Folded like a book: the fold runs vertically, content sits side by side.
            let leading = CGRect(x: 0, y: 0, width: max(division.minX, 0), height: container.height)
            let trailingX = min(division.maxX, container.width)
            let trailing = CGRect(x: trailingX, y: 0, width: container.width - trailingX, height: container.height)
            return .sideBySide(leading: leading, trailing: trailing)
        } else {
            // Folded like a laptop: the fold runs horizontally, content stacks above and below.
            let top = CGRect(x: 0, y: 0, width: container.width, height: max(division.minY, 0))
            let bottomY = min(division.maxY, container.height)
            let bottom = CGRect(x: 0, y: bottomY, width: container.width, height: container.height - bottomY)
            return .stacked(top: top, bottom: bottom)
        }
    }
}
