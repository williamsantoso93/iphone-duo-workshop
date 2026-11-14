import AVFoundation
import SwiftUI

/// Discovers each front camera and shows what it can do: the virtual camera trades depth and top formats
/// for automatic switching, the physical ones keep full capabilities but leave switching to the app.
struct FrontCamerasDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
            ForEach(FrontCamera.allCases) { camera in
                FrontCameraRow(camera: camera, capabilities: camera.device.map(CameraCapabilities.init))
            }
        }
    }
}

/// The headline capabilities of one capture device, read from its formats.
struct CameraCapabilities: Equatable {
    let name: String
    let maxDimensions: CMVideoDimensions
    let maxFrameRate: Double
    let supportsDepth: Bool

    init(device: AVCaptureDevice) {
        let largest = device.formats.max { $0.pixelCount < $1.pixelCount }
        name = device.localizedName
        maxDimensions = largest.map { CMVideoFormatDescriptionGetDimensions($0.formatDescription) }
            ?? CMVideoDimensions(width: 0, height: 0)
        maxFrameRate = device.formats.flatMap(\.videoSupportedFrameRateRanges).map(\.maxFrameRate).max() ?? 0
        supportsDepth = device.formats.contains { !$0.supportedDepthDataFormats.isEmpty }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.maxDimensions.width == rhs.maxDimensions.width
            && lhs.maxDimensions.height == rhs.maxDimensions.height
            && lhs.maxFrameRate == rhs.maxFrameRate && lhs.supportsDepth == rhs.supportsDepth
    }
}

private extension AVCaptureDevice.Format {
    var pixelCount: Int32 {
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        return dimensions.width * dimensions.height
    }
}

private struct FrontCameraRow: View {
    let camera: FrontCamera
    let capabilities: CameraCapabilities?

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
                Label(camera.title, systemImage: camera.systemImage)
                    .font(.headline)
                SymbolChip(symbol: camera.symbol)
                if let capabilities {
                    LabeledContent("Device", value: capabilities.name)
                    LabeledContent("Largest format",
                                   value: "\(capabilities.maxDimensions.width) × \(capabilities.maxDimensions.height)")
                    LabeledContent("Max frame rate", value: "\(Int(capabilities.maxFrameRate)) fps")
                    LabeledContent("Depth", value: capabilities.supportsDepth ? "Supported" : "Not supported")
                } else {
                    Label("Not found on this device", systemImage: "video.slash")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    FrontCamerasDemo()
        .padding()
}
