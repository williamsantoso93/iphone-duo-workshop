import SwiftUI

/// Now Playing beside its transcript. The split only runs side by side, so on a tall pane the transcript steps aside.
struct PodcastMock: View {
    @State private var showsTranscript = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            Group {
                if showsTranscript {
                    ArrangementView {
                        PlayerMock()
                    } secondary: {
                        TranscriptMock()
                    }
                    .arrangementViewStyle(.split.axes(.horizontal))
                } else {
                    PlayerMock()
                }
            }
            .animation(Motion.resolve(Motion.standard, reduceMotion: reduceMotion), value: showsTranscript)
            .navigationTitle("The Fold")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    DismissButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Toggle("Transcript", systemImage: "quote.bubble", isOn: $showsTranscript)
                }
                ToolbarOverflowMenu {
                    Button("Share Episode", systemImage: "square.and.arrow.up") {}
                    Button("Sleep Timer", systemImage: "moon.zzz") {}
                }
            }
        }
    }
}

private struct TranscriptMock: View {
    var body: some View {
        List {
            Section("Transcript") {
                ForEach(MockData.transcript, id: \.time) { entry in
                    HStack(alignment: .firstTextBaseline, spacing: Metrics.spacing) {
                        Text(entry.time)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                        Text(entry.line)
                    }
                }
            }
        }
    }
}

#Preview {
    PodcastMock()
}
