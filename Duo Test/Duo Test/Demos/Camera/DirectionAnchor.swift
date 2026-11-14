import AVFoundation
import AVKit
import SwiftUI

/// A transparent UIKit view that owns an `AVCaptureDeviceDirectionCoordinator`. Directions are reported relative
/// to this view, so it reports the display the demo is on, not the device's static `.front` / `.back`.
struct DirectionAnchor: UIViewRepresentable {
    /// Physical cameras the coordinator should consider.
    static let deviceTypes: [AVCaptureDevice.DeviceType] = [
        .builtInOuterUltraWideCamera, .builtInInnerUltraWideCamera,
        .builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera,
    ]

    let onChange: (CameraDirections) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        let onChange = onChange
        // The handler runs on the main queue; it only maps descriptors and never touches AVFoundation sessions.
        context.coordinator.directionCoordinator = AVCaptureDeviceDirectionCoordinator(
            view: view, deviceTypes: Self.deviceTypes
        ) { map in
            MainActor.assumeIsolated {
                onChange(CameraDirections(map))
            }
        }
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {}

    final class Coordinator {
        var directionCoordinator: AVCaptureDeviceDirectionCoordinator?
    }
}

/// The coordinator's map, copied into plain values the UI can hold.
struct CameraDirections: Equatable, Sendable {
    struct Camera: Equatable, Identifiable, Sendable {
        let id: String
        let name: String
        let position: AVCaptureDevice.Position
    }

    var forward: [Camera] = []
    var backward: [Camera] = []

    init() {}

    init(_ map: AVCaptureDeviceDirectionMap) {
        forward = map.forwardFacingDeviceDescriptors.map(Camera.init)
        backward = map.backwardFacingDeviceDescriptors.map(Camera.init)
    }

    var isEmpty: Bool {
        forward.isEmpty && backward.isEmpty
    }

    /// A back camera facing the person (device flipped open) should get a mirrored preview, like a selfie.
    var mirrorsPreview: Bool {
        forward.first?.position == .back
    }
}

private extension CameraDirections.Camera {
    init(_ descriptor: AVCaptureDeviceDescriptor) {
        self.init(id: descriptor.uniqueID, name: descriptor.localizedName, position: descriptor.position)
    }
}
