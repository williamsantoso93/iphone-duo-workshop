import SwiftUI

/// Maps a use case to its mockup. Each mockup owns its navigation and Close button, because some
/// (Mail's split view, the edge-to-edge calculator and video) can't sit inside a shared navigation stack.
struct UseCaseRouter: View {
    let useCase: UseCase

    var body: some View {
        switch useCase.id {
        case "mail":
            MailContinuityMock()
        case "podcast":
            PodcastMock()
        case "tabletopVideo":
            TabletopVideoMock()
        case "airGuitar":
            AirGuitarMock()
        case "photoGrid":
            PhotoGridMock()
        case "calculator":
            CalculatorMock()
        default:
            NavigationStack {
                ContentUnavailableView("Coming soon", systemImage: "hammer")
                    .navigationTitle(useCase.title)
                    .closeable()
            }
        }
    }
}
