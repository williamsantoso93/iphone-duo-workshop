import SwiftUI

/// A use case: the pitch, the poses it targets, the mockup launcher, and the APIs behind it.
struct UseCaseDetailView: View {
    let useCase: UseCase

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacing * 1.5) {
                Image(systemName: useCase.systemImage)
                    .font(.system(size: 56))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 180)
                    .background(useCase.accent.gradient, in: .rect(cornerRadius: Metrics.cardRadius))

                Text(useCase.summary)
                    .font(.title3)

                PoseChipRow(poses: useCase.poses)

                DemoLauncher(title: "Open mockup", systemImage: "play.fill", embedsInNavigationStack: false) {
                    UseCaseRouter(useCase: useCase)
                }

                VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
                    Text("APIs used")
                        .font(.headline)
                    ForEach(useCase.apiIDs.compactMap { Catalog.api(id: $0) }) { entry in
                        NavigationLink(value: entry) {
                            Card {
                                Label(entry.title, systemImage: entry.area.systemImage)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Metrics.spacing)
        }
        .navigationTitle(useCase.title)
    }
}
