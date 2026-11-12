import SwiftUI

/// Root of each window. The tab bar becomes a sidebar on the inner display and goes vertical where the system places bars on the side.
struct RootView: View {
    @SceneStorage("tab") private var tab: AppTab = .apis

    var body: some View {
        TabView(selection: $tab) {
            Tab("APIs", systemImage: "square.stack.3d.up", value: .apis) {
                APICatalogView()
            }
            Tab("Use Cases", systemImage: "rectangle.split.2x1", value: .useCases) {
                UseCaseCatalogView()
            }
            Tab("Readiness", systemImage: "checklist", value: .readiness) {
                ReadinessView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .defaultTabBarPlacement(.sidebar)
    }
}

#Preview {
    RootView()
}
