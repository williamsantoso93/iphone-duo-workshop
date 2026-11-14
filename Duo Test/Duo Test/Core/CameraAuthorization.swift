import AVFoundation

/// Camera permission, decoupled from `AVAuthorizationStatus` so demo state stays a pure function.
enum CameraAuthorization: Sendable {
    case notDetermined
    case authorized
    case denied

    init(_ status: AVAuthorizationStatus) {
        switch status {
        case .authorized: self = .authorized
        case .notDetermined: self = .notDetermined
        default: self = .denied
        }
    }
}
