import SwiftUI

/// The discrete fold state of the device, read from the SwiftUI hinge API.
enum Posture: String, CaseIterable, Sendable {
    case unavailable
    case closed
    case partiallyOpen
    case fullyOpen

    var title: String {
        switch self {
        case .unavailable: "No hinge"
        case .closed: "Closed"
        case .partiallyOpen: "Partially open"
        case .fullyOpen: "Fully open"
        }
    }

    var systemImage: String {
        switch self {
        case .unavailable: "iphone.slash"
        case .closed: "iphone"
        case .partiallyOpen: "book"
        case .fullyOpen: "book.pages"
        }
    }
}

extension Posture {
    /// Maps the SwiftUI hinge. A `nil` hinge means the device has no hinge.
    init(_ hinge: DeviceHinge?) {
        guard let status = hinge?.status else {
            self = .unavailable
            return
        }
        switch status {
        case .closed: self = .closed
        case .partiallyOpen: self = .partiallyOpen
        case .fullyOpen: self = .fullyOpen
        default: self = .unavailable
        }
    }
}
