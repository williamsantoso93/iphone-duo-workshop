import Foundation

/// The six iPhone Duo tech talks. The raw value is the video ID on developer.apple.com.
enum TechTalk: String, CaseIterable, Sendable {
    case design = "111466"
    case prepare = "111461"
    case raiseTheBar = "111462"
    case strikeAPose = "111463"
    case multipleDisplays = "111464"
    case camera = "111465"

    var title: String {
        switch self {
        case .design: "Design for iPhone Duo"
        case .prepare: "Prepare your app for iPhone Duo"
        case .raiseTheBar: "Raise the bar with iPhone Duo"
        case .strikeAPose: "Strike a pose with adaptive layouts on iPhone Duo"
        case .multipleDisplays: "Leverage multiple displays and scenes on iPhone Duo"
        case .camera: "Build a great camera experience for iPhone Duo"
        }
    }

    var url: URL {
        URL(string: "https://developer.apple.com/videos/play/tech-talks/\(rawValue)/")!
    }
}
