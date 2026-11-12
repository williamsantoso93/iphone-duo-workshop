import Foundation

/// Groups the showcased APIs the way the tech talks present them.
enum APIArea: String, CaseIterable, Sendable {
    case layout
    case bars
    case regions
    case arrangements
    case hinge
    case scenes
    case camera

    var title: String {
        switch self {
        case .layout: "Adaptive Layout"
        case .bars: "Vertical Bars"
        case .regions: "Reserved Regions"
        case .arrangements: "Arrangements"
        case .hinge: "Hinge"
        case .scenes: "Scenes & Displays"
        case .camera: "Camera"
        }
    }

    var systemImage: String {
        switch self {
        case .layout: "aspectratio"
        case .bars: "sidebar.right"
        case .regions: "square.dashed"
        case .arrangements: "rectangle.split.2x1"
        case .hinge: "book.pages"
        case .scenes: "macwindow.on.rectangle"
        case .camera: "camera"
        }
    }
}
