import SwiftUI

/// Every showcased API, grouped by area. Collapses to a single stack on the outer display.
struct APICatalogView: View {
    @SceneStorage("api.selection") private var selectedID: String?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedID) {
                ForEach(APIArea.allCases, id: \.self) { area in
                    Section {
                        ForEach(Catalog.apis.filter { $0.area == area }) { entry in
                            NavigationLink(entry.title, value: entry.id)
                        }
                    } header: {
                        Label(area.title, systemImage: area.systemImage)
                    }
                }
            }
            .navigationTitle("APIs")
        } detail: {
            if let selectedID, let entry = Catalog.api(id: selectedID) {
                APIDetailView(entry: entry)
            } else {
                ContentUnavailableView("Choose an API", systemImage: "square.stack.3d.up", description: Text("Each demo reacts live as you open, fold, and rotate iPhone Duo."))
            }
        }
    }
}
