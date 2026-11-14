import SwiftUI

/// Flat, the controls float over the video. Folded like a laptop, the overlay arrangement splits them:
/// video on the top half, a stable deck of controls on the bottom half.
struct TabletopVideoMock: View {
    @State private var isPlaying = true
    @State private var position = 0.42
    @State private var videoFrame = CGRect.null
    @State private var deckFrame = CGRect.null
    @State private var deckZIndex = 0

    /// Where the arrangement has no room for the secondary (a flat outer display) the deck sits level
    /// with the video and stays hidden, so the video carries its own floating controls until the deck
    /// either floats above it or splits below it.
    private var showsDeck: Bool {
        !deckFrame.isNull && !videoFrame.isNull && (deckZIndex > 0 || !deckFrame.intersects(videoFrame))
    }

    var body: some View {
        ArrangementView {
            VideoMock()
                .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { videoFrame = $0 }
                .overlay(alignment: .bottom) {
                    if !showsDeck {
                        VideoControls(isPlaying: $isPlaying, position: $position, isFloating: true)
                    }
                }
        } secondary: {
            VideoDeck(isPlaying: $isPlaying, position: $position, zIndex: $deckZIndex)
                .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { deckFrame = $0 }
                .onDisappear { deckFrame = .null }
                .accessibilityHidden(!showsDeck)
        }
        .arrangementViewStyle(.overlay)
        .background(.black)
        .floatingCloseButton()
    }
}

private struct VideoMock: View {
    var body: some View {
        LinearGradient(colors: [.teal, .indigo, .black], startPoint: .top, endPoint: .bottom)
            .overlay {
                VStack(spacing: Metrics.compactSpacing) {
                    Image(systemName: "mountain.2.fill")
                        .font(.system(size: 64))
                    Text("Coastal Drive")
                        .font(.title.bold())
                }
                .foregroundStyle(.white.opacity(0.9))
                .accessibilityElement(children: .combine)
            }
            .ignoresSafeArea()
    }
}

/// The secondary view. Floats as a compact glass row while it overlays the video, and becomes
/// a full control deck once split below it.
private struct VideoDeck: View {
    @Binding var isPlaying: Bool
    @Binding var position: Double
    /// Reports the arrangement's z-index up, so the video knows whether the deck is on screen.
    @Binding var zIndex: Int
    @Environment(\.overlayArrangementZIndex) private var arrangementZIndex

    private var isOverlay: Bool {
        arrangementZIndex > 0
    }

    var body: some View {
        VStack(spacing: Metrics.spacing) {
            if !isOverlay {
                Text("Coastal Drive · 12:48")
                    .font(.headline)
            }
            VideoControls(isPlaying: $isPlaying, position: $position, isFloating: isOverlay)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isOverlay ? .bottom : .center)
        .background {
            if !isOverlay {
                Rectangle().fill(.background).ignoresSafeArea()
            }
        }
        .onChange(of: arrangementZIndex, initial: true) { zIndex = arrangementZIndex }
    }
}

private struct VideoControls: View {
    @Binding var isPlaying: Bool
    @Binding var position: Double
    let isFloating: Bool

    var body: some View {
        VStack(spacing: Metrics.spacing) {
            Slider(value: $position)
                .accessibilityLabel("Playback position")
            GlassEffectContainer {
                HStack(spacing: Metrics.spacing) {
                    Button("Back 10 seconds", systemImage: "gobackward.10") {}
                        .buttonStyle(.glass)
                    Button(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill") {
                        isPlaying.toggle()
                    }
                    .buttonStyle(.glassProminent)
                    .contentTransition(.symbolEffect(.replace))
                    Button("Forward 10 seconds", systemImage: "goforward.10") {}
                        .buttonStyle(.glass)
                }
                .labelStyle(.iconOnly)
                .controlSize(isFloating ? .large : .extraLarge)
            }
        }
        .padding(Metrics.spacing)
        .frame(maxWidth: 480)
        .glassEffect(isFloating ? .regular : .identity, in: .rect(cornerRadius: Metrics.cardRadius))
        .padding(Metrics.spacing)
    }
}

#Preview {
    TabletopVideoMock()
}
