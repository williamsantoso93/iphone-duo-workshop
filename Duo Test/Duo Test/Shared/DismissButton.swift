import SwiftUI

/// Closes the full-screen demo it lives in. Demos that own their bars place it themselves.
struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button("Close", systemImage: "xmark") {
            dismiss()
        }
    }
}
