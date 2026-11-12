import SwiftUI

/// One readiness fix: what to stop doing and what to do instead.
struct ReadinessRow: View {
    let item: ReadinessItem
    @Binding var isDone: Bool

    var body: some View {
        Toggle(isOn: $isDone) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                Group {
                    Label {
                        Text(verbatim: item.avoid)
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.red)
                    Label {
                        Text(verbatim: item.prefer)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .foregroundStyle(.green)
                }
                .font(.callout)
                .fontDesign(.monospaced)
            }
        }
        .toggleStyle(.checklist)
    }
}
