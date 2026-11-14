import Foundation

/// One fix from Apple's "Three steps to make your app shine on iPhone Duo".
struct ReadinessItem: Identifiable, Hashable, Sendable {
    let id: String
    let step: Int
    let title: String
    let avoid: String
    let prefer: String
}
