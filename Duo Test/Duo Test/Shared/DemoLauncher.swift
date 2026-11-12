import SwiftUI

/// Presents a demo full screen so its bars belong to the window (and can go vertical on iPhone Duo),
/// instead of nesting a second navigation stack inside the catalog's detail column.
struct DemoLauncher<Demo: View>: View {
    var title: LocalizedStringKey = "Open demo"
    var systemImage = "play.fill"
    /// Demos that own their bars (tab views, their own navigation stacks, edge-to-edge canvases)
    /// pass `false` and place a `DismissButton` themselves.
    var embedsInNavigationStack = true
    @ContentBuilder let demo: () -> Demo

    @State private var isPresented = false

    var body: some View {
        Button(title, systemImage: systemImage, action: present)
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            // Reading `isPresented` in `body` keeps the cover subscribed to it; with only the `$isPresented`
            // binding, the SDK 27 `@State` macro sometimes drops the change and the cover never appears.
            .disabled(isPresented)
            .fullScreenCover(isPresented: $isPresented) {
                if embedsInNavigationStack {
                    NavigationStack {
                        demo()
                            .closeable()
                    }
                } else {
                    demo()
                }
            }
    }

    private func present() {
        isPresented = true
    }
}
