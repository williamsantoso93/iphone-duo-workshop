import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }

        WindowGroup("Detail", id: "detail", for: String.self) { $entryID in
            DetailWindowRoot(entryID: entryID)
        }
    }
}
