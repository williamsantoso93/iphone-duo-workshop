import SwiftUI

/// A podcast player: artwork, title, progress, and floating glass transport controls.
struct PlayerMock: View {
    @State private var isPlaying = false

    var body: some View {
        VStack(spacing: Metrics.spacing) {
            Spacer(minLength: 0)
            // Artwork gives up height first, so a short pane (split, stacked) still shows the controls.
            Image(systemName: "waveform")
                .font(.system(size: 48, weight: .semibold))
                .symbolEffect(.variableColor.iterative, isActive: isPlaying)
                .frame(maxWidth: 140, maxHeight: 140)
                .aspectRatio(1, contentMode: .fit)
                .background(.white.opacity(0.18), in: .rect(cornerRadius: 28))
                .layoutPriority(-1)
            VStack(spacing: 4) {
                Text("The Fold, Episode 42")
                    .font(.title2.bold())
                Text("Designing for two displays")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .multilineTextAlignment(.center)
            ProgressView(value: 0.35)
                .tint(.white)
                .frame(maxWidth: 320)
                .accessibilityLabel("Playback position")
            Spacer(minLength: 0)
            controls
        }
        .foregroundStyle(.white)
        .padding(Metrics.spacing)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.indigo, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
    }

    private var controls: some View {
        GlassEffectContainer {
            HStack(spacing: Metrics.spacing) {
                Button("Back 15 seconds", systemImage: "gobackward.15") {}
                    .buttonStyle(.glass)
                Button(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill") {
                    isPlaying.toggle()
                }
                .buttonStyle(.glassProminent)
                .contentTransition(.symbolEffect(.replace))
                Button("Forward 30 seconds", systemImage: "goforward.30") {}
                    .buttonStyle(.glass)
            }
            .labelStyle(.iconOnly)
            .controlSize(.extraLarge)
        }
    }
}

#Preview {
    PlayerMock()
}
