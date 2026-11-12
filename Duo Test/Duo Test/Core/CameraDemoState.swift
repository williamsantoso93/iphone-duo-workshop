import Foundation

/// What a camera demo screen can show. The simulator always lands on `.noCamera`.
enum CameraDemoState: Equatable, Sendable {
    case needsPermission
    case permissionDenied
    case noCamera
    case ready

    static func resolve(authorization: CameraAuthorization, hasDevices: Bool) -> CameraDemoState {
        switch authorization {
        case .denied: .permissionDenied
        case .notDetermined: .needsPermission
        case .authorized: hasDevices ? .ready : .noCamera
        }
    }
}
