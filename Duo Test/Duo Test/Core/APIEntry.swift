import Foundation

/// One showcased API (or tightly related API set) with its SwiftUI spellings.
struct APIEntry: Identifiable, Hashable, Sendable {
    let id: String
    let area: APIArea
    let title: String
    let summary: String
    let swiftUISymbols: [String]
    /// Non-SwiftUI framework symbols the demo needs (AVFoundation for the cameras); empty for pure SwiftUI APIs.
    let frameworkSymbols: [String]
    let talk: TechTalk
    /// The live path needs physical hardware (cameras); the simulator shows an explanatory state.
    let deviceOnly: Bool
}
