import SwiftUI

/// A content card. Content is not floating chrome, so it uses a solid secondary background rather than glass.
struct Card<Content: View>: View {
    private let content: Content

    init(@ContentBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Metrics.spacing)
            .background(.background.secondary, in: .rect(cornerRadius: Metrics.cardRadius))
    }
}
