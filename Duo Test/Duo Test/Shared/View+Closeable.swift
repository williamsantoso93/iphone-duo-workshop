import SwiftUI

extension View {
    /// Adds a Close button as the cancellation action of the enclosing navigation bar.
    func closeable() -> some View {
        toolbar {
            ToolbarItem(placement: .cancellationAction) {
                DismissButton()
            }
        }
    }

    /// Floats a glass Close button over a demo that has no navigation bar of its own.
    func floatingCloseButton() -> some View {
        overlay(alignment: .topLeading) {
            DismissButton()
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
                .padding()
        }
    }
}
