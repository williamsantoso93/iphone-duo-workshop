import SwiftUI

extension UseCase {
    /// A system color per use case, so cards stay distinguishable in light and dark mode.
    var accent: Color {
        switch id {
        case "mail": .blue
        case "podcast": .purple
        case "tabletopVideo": .red
        case "airGuitar": .orange
        case "teleprompter": .teal
        case "photoGrid": .pink
        case "calculator": .indigo
        default: .accentColor
        }
    }
}
