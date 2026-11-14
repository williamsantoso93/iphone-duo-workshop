import SwiftUI

/// A leading check circle, like Reminders, that toggles the whole row.
struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                    .font(.title3)
                    .contentTransition(.symbolEffect(.replace))
                configuration.label
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(configuration.isOn ? .isSelected : [])
    }
}

extension ToggleStyle where Self == ChecklistToggleStyle {
    static var checklist: ChecklistToggleStyle { ChecklistToggleStyle() }
}
