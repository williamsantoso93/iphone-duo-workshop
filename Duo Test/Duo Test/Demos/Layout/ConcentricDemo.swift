import SwiftUI

/// Corners that follow the display's own rounded corners, on both displays and in every pose.
struct ConcentricDemo: View {
    var body: some View {
        ZStack {
            ConcentricRectangle()
                .fill(Color.accentColor.gradient)
                .padding(8)
                .ignoresSafeArea()

            VStack(spacing: Metrics.spacing) {
                Image(systemName: "rectangle.inset.filled")
                    .font(.system(size: 48))
                Text("ConcentricRectangle")
                    .font(.title2.bold())
                    .fontDesign(.monospaced)
                Text("The fill sits 8 pt inside the screen edge and its corners stay concentric with the display.")
                    .multilineTextAlignment(.center)

                Text("Nested shape")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .background(.white.opacity(0.25), in: ConcentricRectangle())
                    .containerShape(.rect(cornerRadius: Metrics.cardRadius + 12))
            }
            .foregroundStyle(.white)
            .padding(Metrics.spacing * 2)
        }
        .floatingCloseButton()
    }
}

#Preview {
    ConcentricDemo()
}
