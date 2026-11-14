import SwiftUI

/// An API symbol name, set in monospace so it reads as code.
struct SymbolChip: View {
    let symbol: String

    var body: some View {
        Text(verbatim: symbol)
            .font(.caption)
            .fontDesign(.monospaced)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.background.tertiary, in: .capsule)
    }
}
