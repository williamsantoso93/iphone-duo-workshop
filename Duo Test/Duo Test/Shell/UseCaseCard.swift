import SwiftUI

/// A use case preview: a tinted artwork band, the title, a one-line pitch, and the poses it targets.
struct UseCaseCard: View {
    let useCase: UseCase

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.spacing) {
            Image(systemName: useCase.systemImage)
                .font(.largeTitle)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 110)
                .background(useCase.accent.gradient, in: .rect(cornerRadius: Metrics.cardRadius - 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(useCase.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Text(useCase.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3, reservesSpace: true)
            }

            PoseChipRow(poses: useCase.poses)
        }
        .padding(Metrics.compactSpacing)
        .background(.background.secondary, in: .rect(cornerRadius: Metrics.cardRadius))
        .contentShape(.rect(cornerRadius: Metrics.cardRadius))
    }
}
