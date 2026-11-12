import SwiftUI

/// A second window opened from the multi-window demo, showing one API on its own.
struct DetailWindowRoot: View {
    let entryID: String?

    var body: some View {
        NavigationStack {
            if let entryID, let entry = Catalog.api(id: entryID) {
                APIDetailView(entry: entry)
            } else {
                ContentUnavailableView("Nothing to show", systemImage: "macwindow")
            }
        }
    }
}
