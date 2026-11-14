import SwiftUI

/// Sheets get vertical bars too, unless they opt out; on the inner display they can be placed beside the fold.
struct SheetBarsDemo: View {
    @State private var isShowingDefault = false
    @State private var isShowingOptOut = false
    @State private var placement = PresentationPlacement.automatic

    var body: some View {
        Form {
            Section {
                Button("Show default sheet", systemImage: "rectangle.bottomhalf.inset.filled") {
                    isShowingDefault = true
                }
                Button("Show sheet with vertical bars disabled", systemImage: "rectangle.slash") {
                    isShowingOptOut = true
                }
            } footer: {
                Text("Opt out only when the content truly needs the full width, such as a wide editor.")
            }
            Section {
                Picker("Placement", selection: $placement) {
                    Text("Automatic").tag(PresentationPlacement.automatic)
                    Text("Leading").tag(PresentationPlacement.leading)
                    Text("Center").tag(PresentationPlacement.center)
                    Text("Trailing").tag(PresentationPlacement.trailing)
                }
            } header: {
                Text("Inner display")
            } footer: {
                Text(verbatim: ".presentationPlacement(_:)")
                    .fontDesign(.monospaced)
            }
        }
        .navigationTitle("Sheets")
        .sheet(isPresented: $isShowingDefault) {
            sheetContent("Default")
                .presentationPlacement(placement)
        }
        .sheet(isPresented: $isShowingOptOut) {
            sheetContent("Opted out")
                .toolbarVerticalBehavior(.disabled)
                .presentationPlacement(placement)
        }
    }

    private func sheetContent(_ title: LocalizedStringKey) -> some View {
        NavigationStack {
            List(1...20, id: \.self) { index in
                Text("Row \(index)")
            }
            .navigationTitle(title)
            .closeable()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Share", systemImage: "square.and.arrow.up") {}
                    Button("Favorite", systemImage: "star") {}
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SheetBarsDemo()
    }
}
