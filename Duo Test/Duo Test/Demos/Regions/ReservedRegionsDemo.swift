import SwiftUI

/// Draws the fold (division) and cameras (occlusions), displaces one Now Playing card around the fold,
/// keeps a custom bar clear of the camera, and leaves the scrolling list underneath alone.
struct ReservedRegionsDemo: View {
    @State private var includeInactive = false
    @State private var isAlertPresented = false
    @State private var isDialogPresented = false
    @State private var isSheetPresented = false
    @State private var barWidth: CGFloat = 0
    @State private var insets = EdgeInsets()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let barHeight: CGFloat = 52

    var body: some View {
        ZStack {
            list
                // The region layer ignores the safe area (so its proxy reports none); measure it here instead.
                .onGeometryChange(for: EdgeInsets.self, of: \.safeAreaInsets) { insets = $1 }
            GeometryReader { proxy in
                regionLayer(proxy)
            }
            .ignoresSafeArea()
        }
    }

    // MARK: Regions, displacement, custom bar

    private func regionLayer(_ proxy: GeometryProxy) -> some View {
        let options: ReservedRegion.QueryOptions = includeInactive ? .includeInactive : []
        let divisions = proxy.reservedRegions(kind: .division, options: options)
        let occlusions = proxy.reservedRegions(kind: .occlusion, options: options)
        // Only an active division splits the content; an inactive one is the flat fold.
        let panes = FoldSplit.panes(container: proxy.size, division: divisions.first(where: \.isActive)?.frame)
        // Test the bar's real frame: only an occlusion it actually overlaps (the inner camera) pushes it down.
        let barFrame = CGRect(x: insets.leading + Metrics.spacing, y: insets.top, width: barWidth, height: barHeight)
        let activeOcclusions = occlusions.filter(\.isActive).map(\.frame)
        let barTop = max(insets.top, OcclusionAvoidance.topInset(barFrame: barFrame, occlusions: activeOcclusions))

        return ZStack(alignment: .topLeading) {
            ForEach(divisions + occlusions) { region in
                RegionOutline(region: region, containerWidth: proxy.size.width)
            }
            nowPlaying(in: panes, insets: insets)
            customBar(panes: panes)
                .padding(.top, barTop)
                .padding(.leading, insets.leading + Metrics.spacing)
                .padding(.trailing, insets.trailing + Metrics.spacing)
        }
        .animation(Motion.resolve(Motion.standard, reduceMotion: reduceMotion), value: panes)
    }

    /// Book: the whole card moves to the trailing pane, nearest the outer display.
    /// Tabletop: information goes up, the controls you tap come down.
    @ViewBuilder
    private func nowPlaying(in panes: FoldPanes, insets: EdgeInsets) -> some View {
        let padding = EdgeInsets(
            top: insets.top + Metrics.spacing, leading: insets.leading + Metrics.spacing,
            bottom: insets.bottom + Metrics.spacing, trailing: insets.trailing + Metrics.spacing)
        switch panes {
        case .single(let rect):
            NowPlayingCard()
                .placed(in: rect, alignment: .bottom, padding: padding)
        case .sideBySide(_, let trailing):
            NowPlayingCard()
                .placed(in: trailing, alignment: .bottom, padding: padding)
        case .stacked(let top, let bottom):
            NowPlayingInfo()
                .padding(Metrics.spacing)
                .glassEffect(.regular, in: .rect(cornerRadius: Metrics.cardRadius))
                .placed(in: top, alignment: .center, padding: padding)
            NowPlayingControls()
                .placed(in: bottom, alignment: .center, padding: padding)
        }
    }

    private func customBar(panes: FoldPanes) -> some View {
        GlassEffectContainer {
            HStack(spacing: Metrics.compactSpacing) {
                DismissButton()
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                VStack(alignment: .leading) {
                    Text("Reserved Regions")
                        .font(.headline)
                    Text(panes.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .contentTransition(.opacity)
                }
                .padding(.horizontal, Metrics.spacing)
                .padding(.vertical, 6)
                .glassEffect(.regular, in: .capsule)
            }
        }
        .frame(height: barHeight)
        .onGeometryChange(for: CGFloat.self, of: \.size.width) { barWidth = $1 }
    }

    // MARK: Scrolling content (never displaced)

    private var list: some View {
        List {
            Section {
                Toggle("Include inactive", isOn: $includeInactive)
            } footer: {
                Text("Flat, the fold is an inactive division with zero width; the dashed line marks where it would be.")
            }

            Section {
                Button("Show alert") { isAlertPresented = true }
                Button("Show confirmation dialog") { isDialogPresented = true }
                Menu("Show menu") {
                    Button("Copy", systemImage: "doc.on.doc") {}
                    Button("Share", systemImage: "square.and.arrow.up") {}
                }
                Text("Touch and hold for a context menu")
                    .contextMenu {
                        Button("Copy", systemImage: "doc.on.doc") {}
                        Button("Share", systemImage: "square.and.arrow.up") {}
                    }
                Button("Show sheet") { isSheetPresented = true }
            } header: {
                Text("System fold avoidance")
            } footer: {
                Text("System components move clear of the fold on their own, with no extra code.")
            }

            Section {
                ForEach(1...30, id: \.self) { number in
                    Label("Episode \(number)", systemImage: "waveform")
                }
            } header: {
                Text("Scrolling content")
            } footer: {
                Text("Continuous scrolling content is never displaced.")
            }
        }
        .contentMargins(.top, barHeight + Metrics.spacing, for: .scrollContent)
        .contentMargins(.bottom, 220, for: .scrollContent)
        .alert("Alerts avoid the fold", isPresented: $isAlertPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("On a folded device the system places this alert in one pane.")
        }
        .confirmationDialog("Dialogs avoid the fold", isPresented: $isDialogPresented, titleVisibility: .visible) {
            Button("Archive") {}
            Button("Delete", role: .destructive) {}
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                ContentUnavailableView("Sheets avoid the fold", systemImage: "rectangle.portrait.bottomhalf.inset.filled")
                    .closeable()
            }
        }
    }
}

// MARK: - Region outline

/// Division in orange, occlusion in red; inactive regions are dashed (a flat fold draws as a line).
private struct RegionOutline: View {
    let region: ReservedRegion
    let containerWidth: CGFloat

    private var color: Color {
        region.kind == .division ? .orange : .red
    }

    var body: some View {
        let frame = region.frame
        // Labels hang inward, so a region on the trailing edge doesn't push its label off screen.
        let labelAlignment: Alignment = frame.midX > containerWidth / 2 ? .topTrailing : .topLeading
        Rectangle()
            .fill(color.opacity(region.isActive ? 0.3 : 0))
            .stroke(color, style: StrokeStyle(lineWidth: 2, dash: region.isActive ? [] : [6, 4]))
            .frame(width: frame.width, height: frame.height)
            .overlay(alignment: labelAlignment) {
                Text("\(region.kind == .division ? "division" : "occlusion") · \(region.isActive ? "active" : "inactive")")
                    .font(.caption2.monospaced())
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(color, in: .capsule)
                    .foregroundStyle(.white)
                    .fixedSize()
                    .offset(y: frame.height + 4)
            }
            .offset(x: frame.minX, y: frame.minY)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

// MARK: - Now Playing

private struct NowPlayingCard: View {
    var body: some View {
        VStack(spacing: Metrics.spacing) {
            NowPlayingInfo()
            NowPlayingControls()
        }
        .padding(Metrics.spacing)
        .frame(maxWidth: 360)
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.cardRadius))
    }
}

private struct NowPlayingInfo: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "waveform")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.indigo.gradient, in: .rect(cornerRadius: 10))
            VStack(alignment: .leading) {
                Text("Now Playing")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("The Fold, Episode 42")
                    .font(.headline)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct NowPlayingControls: View {
    @State private var isPlaying = false

    var body: some View {
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
            .controlSize(.large)
        }
    }
}

// MARK: - Helpers

private extension FoldPanes {
    var title: String {
        switch self {
        case .single: "One pane · not folded"
        case .sideBySide: "Side by side · book"
        case .stacked: "Stacked · tabletop"
        }
    }
}

private extension View {
    /// Lays the view out inside `rect` (in the enclosing top-leading coordinate space).
    func placed(in rect: CGRect, alignment: Alignment, padding: EdgeInsets) -> some View {
        self
            .padding(padding)
            .frame(width: rect.width, height: rect.height, alignment: alignment)
            .offset(x: rect.minX, y: rect.minY)
    }
}

#Preview {
    ReservedRegionsDemo()
}
