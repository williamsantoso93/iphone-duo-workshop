import AVFoundation
import SwiftUI

/// `position == .front` can face away from the person on iPhone Duo. The direction coordinator says which cameras
/// face forward and backward relative to this view, and updates as the device opens, closes, or flips.
struct DirectionCoordinatorDemo: View {
    @State private var directions = CameraDirections()

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
            // The map stays empty until the first callback, which never comes without cameras.
            if directions.isEmpty {
                Card {
                    Label("No cameras reported on this device", systemImage: "video.slash")
                        .foregroundStyle(.secondary)
                }
            } else {
                section("Facing you", systemImage: "person.crop.circle", cameras: directions.forward)
                section("Facing away", systemImage: "mountain.2", cameras: directions.backward)
                Label(directions.mirrorsPreview ? "Mirror the preview: a back camera is facing you"
                                                : "No mirroring needed",
                      systemImage: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .background {
            DirectionAnchor { directions = $0 }
            .accessibilityHidden(true)
        }
    }

    private func section(_ title: LocalizedStringKey, systemImage: String,
                         cameras: [CameraDirections.Camera]) -> some View {
        Card {
            VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                if cameras.isEmpty {
                    Text("None")
                        .foregroundStyle(.secondary)
                }
                ForEach(cameras) { camera in
                    LabeledContent(camera.name, value: camera.position.label)
                }
            }
            .font(.subheadline)
        }
    }
}

private extension AVCaptureDevice.Position {
    var label: String {
        switch self {
        case .front: "position .front"
        case .back: "position .back"
        default: "position .unspecified"
        }
    }
}

#Preview {
    DirectionCoordinatorDemo()
        .padding()
}
