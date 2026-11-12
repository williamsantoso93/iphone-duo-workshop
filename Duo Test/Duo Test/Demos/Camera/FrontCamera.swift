import AVFoundation

/// The three ways to reach a front camera on iPhone Duo, each found with its own discovery session.
enum FrontCamera: CaseIterable, Identifiable {
    /// Switches between the inner and outer ultra wide cameras for you; shared features only.
    case virtual
    case outerUltraWide
    case innerUltraWide

    var id: Self { self }

    var title: String {
        switch self {
        case .virtual: "Virtual Front Camera"
        case .outerUltraWide: "Outer Ultra Wide"
        case .innerUltraWide: "Inner Ultra Wide"
        }
    }

    var systemImage: String {
        switch self {
        case .virtual: "arrow.triangle.2.circlepath.camera"
        case .outerUltraWide: "camera"
        case .innerUltraWide: "camera.viewfinder"
        }
    }

    var symbol: String {
        switch self {
        case .virtual: ".front + wide/ultra wide"
        case .outerUltraWide: ".builtInOuterUltraWideCamera"
        case .innerUltraWide: ".builtInInnerUltraWideCamera"
        }
    }

    /// The first matching device, or nil where the hardware doesn't exist (the simulator).
    var device: AVCaptureDevice? {
        let session = switch self {
        case .virtual:
            AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera],
                                             mediaType: .video, position: .front)
        case .outerUltraWide:
            AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInOuterUltraWideCamera],
                                             mediaType: .video, position: .unspecified)
        case .innerUltraWide:
            AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInInnerUltraWideCamera],
                                             mediaType: .video, position: .unspecified)
        }
        return session.devices.first
    }
}
