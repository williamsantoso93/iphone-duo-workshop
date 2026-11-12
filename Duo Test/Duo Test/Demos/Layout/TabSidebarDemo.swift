import SwiftUI

/// A tab view that becomes a sidebar on the inner display and a vertical bar on the outer display.
struct TabSidebarDemo: View {
    @State private var prefersSidebar = true

    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical") {
                NavigationStack {
                    Form {
                        Toggle("Default to sidebar", isOn: $prefersSidebar)
                        Section {
                            Text(verbatim: prefersSidebar ? ".defaultTabBarPlacement(.sidebar)" : ".defaultTabBarPlacement(.automatic)")
                                .font(.callout)
                                .fontDesign(.monospaced)
                        } footer: {
                            Text("Unfold to see the sidebar on the inner display. On the outer display the tab bar becomes a vertical bar beside the camera.")
                        }
                    }
                    .navigationTitle("Library")
                    .closeable()
                }
            }
            Tab("Recents", systemImage: "clock") {
                page("Recents", systemImage: "clock")
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                page("Search", systemImage: "magnifyingglass")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .defaultTabBarPlacement(prefersSidebar ? .sidebar : .automatic)
    }

    private func page(_ title: LocalizedStringKey, systemImage: String) -> some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: systemImage)
                .navigationTitle(title)
                .closeable()
        }
    }
}

#Preview {
    TabSidebarDemo()
}
