import SwiftUI

/// Use case mockups as cards; each card zooms into its detail and back out to the same card.
struct UseCaseCatalogView: View {
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 260), spacing: Metrics.spacing, alignment: .top)], spacing: Metrics.spacing) {
                    ForEach(Catalog.useCases) { useCase in
                        NavigationLink(value: useCase) {
                            UseCaseCard(useCase: useCase)
                        }
                        .buttonStyle(.plain)
                        .matchedTransitionSource(id: useCase.id, in: namespace)
                    }
                }
                .padding(Metrics.spacing)
            }
            .navigationTitle("Use Cases")
            .navigationDestination(for: UseCase.self) { useCase in
                UseCaseDetailView(useCase: useCase)
                    .navigationTransition(.zoom(sourceID: useCase.id, in: namespace))
            }
            .navigationDestination(for: APIEntry.self) { entry in
                APIDetailView(entry: entry)
            }
        }
    }
}
