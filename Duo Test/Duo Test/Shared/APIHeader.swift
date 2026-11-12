import SwiftUI

/// Summary, API spellings, and the source tech talk for one showcased API.
struct APIHeader: View {
    let entry: APIEntry

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.spacing) {
            Text(entry.summary)
                .font(.title3)

            if entry.deviceOnly {
                Label("Live path needs a physical iPhone Duo", systemImage: "iphone.gen3")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.orange)
            }

            SymbolGroup(title: "SwiftUI", symbols: entry.swiftUISymbols)
            SymbolGroup(title: "Frameworks", symbols: entry.frameworkSymbols)

            Link(destination: entry.talk.url) {
                Label(entry.talk.title, systemImage: "play.rectangle")
                    .font(.subheadline)
            }
        }
    }
}
