import Foundation

/// A mock app that shows several iPhone Duo APIs working together.
struct UseCase: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let summary: String
    let systemImage: String
    let poses: [Posture]
    let apiIDs: [String]
}
