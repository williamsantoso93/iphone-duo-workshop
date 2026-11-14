import AVFoundation
import SwiftUI

/// While the camera runs full screen on the inner display, a `CameraCaptureAccessory` puts extra UI on the outer
/// display for the person being photographed. The system decides availability, so the toggle follows
/// `onAvailabilityChange` and turns off when, for example, the device closes.
struct CameraAccessoryDemo: View {
    @State private var camera = CameraSession()
    @State private var authorization = CameraAuthorization(AVCaptureDevice.authorizationStatus(for: .video))
    @State private var showsAccessory = true
    @State private var isAccessoryAvailable = false

    private var state: CameraDemoState {
        CameraDemoState.resolve(authorization: authorization, hasDevices: AVCaptureDevice.default(for: .video) != nil)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch state {
            case .ready:
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
                    .accessibilityLabel("Camera preview")
                    .overlay(alignment: .bottom) { controls }
            case .needsPermission:
                ContentUnavailableView {
                    Label("Camera access needed", systemImage: "camera")
                } description: {
                    Text("The outer display accessory only appears while a camera session is running.")
                } actions: {
                    Button("Allow Camera") {
                        Task { await requestAccess() }
                    }
                    .buttonStyle(.glassProminent)
                }
            case .permissionDenied:
                ContentUnavailableView("Camera access denied", systemImage: "video.slash",
                                       description: Text("Allow camera access in Settings to try the accessory."))
            case .noCamera:
                ContentUnavailableView("No camera on this device", systemImage: "video.slash",
                                       description: Text("The accessory needs a running camera session, full screen on the inner display."))
            }
        }
        .environment(\.colorScheme, .dark)
        .floatingCloseButton()
        .modifier(OuterDisplayAccessory(isEnabled: $showsAccessory, isAvailable: $isAccessoryAvailable))
        .task(id: state) {
            guard state == .ready else { return }
            _ = await camera.start()
        }
        .onDisappear {
            Task { [camera] in await camera.stop() }
        }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
            Toggle("Show on outer display", systemImage: "rectangle.on.rectangle", isOn: $showsAccessory)
                .disabled(!isAccessoryAvailable)
            Label(isAccessoryAvailable ? "Accessory available" : "Unavailable: run full screen on the inner display",
                  systemImage: isAccessoryAvailable ? "checkmark.circle" : "exclamationmark.circle")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(Metrics.spacing)
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.cardRadius))
        .padding(Metrics.spacing)
    }

    private func requestAccess() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        authorization = granted ? .authorized : .denied
    }
}

/// Attaches the `CameraCaptureAccessory`. The Simulator has no outer camera display, so the accessory can never
/// become available there, and attaching it stalls Simulator touch input; it's only attached on device.
private struct OuterDisplayAccessory: ViewModifier {
    @Binding var isEnabled: Bool
    @Binding var isAvailable: Bool

    func body(content: Content) -> some View {
        #if targetEnvironment(simulator)
        content
        #else
        content.sceneAccessory {
            CameraCaptureAccessory(isEnabled: $isEnabled) {
                OuterDisplayPrompt()
            }
            .onAvailabilityChange { isAvailable = $0 }
        }
        #endif
    }
}

/// What the person in front of the outer display sees while they're being photographed.
private struct OuterDisplayPrompt: View {
    var body: some View {
        VStack(spacing: Metrics.spacing) {
            Image(systemName: "face.smiling")
                .font(.system(size: 72))
                .symbolEffect(.bounce, options: .repeating)
            Text("Look up and smile")
                .font(.largeTitle.bold())
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    CameraAccessoryDemo()
}
