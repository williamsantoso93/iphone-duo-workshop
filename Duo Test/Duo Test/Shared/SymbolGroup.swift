import SwiftUI

/// A titled, wrapping set of API symbol chips. Hidden when there are no symbols.
struct SymbolGroup: View {
    let title: LocalizedStringKey
    let symbols: [String]

    var body: some View {
        if !symbols.isEmpty {
            VStack(alignment: .leading, spacing: Metrics.compactSpacing) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), alignment: .leading)], alignment: .leading, spacing: Metrics.compactSpacing) {
                    ForEach(symbols, id: \.self) { symbol in
                        SymbolChip(symbol: symbol)
                    }
                }
            }
        }
    }
}
