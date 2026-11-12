import SwiftUI

/// Maps a catalog entry to its live demo. Demos that need the whole window (edge-to-edge canvases, their own bars)
/// open full screen through `DemoLauncher`; the rest render inline.
struct APIDemoRouter: View {
    let entry: APIEntry

    var body: some View {
        switch entry.id {
        case "sizeClasses":
            SizeClassDemo()
        case "asymmetricSafeArea":
            DemoLauncher(embedsInNavigationStack: false) {
                SafeAreaDemo()
            }
        case "concentricity":
            DemoLauncher(embedsInNavigationStack: false) {
                ConcentricDemo()
            }
        case "tabSidebar":
            DemoLauncher(embedsInNavigationStack: false) {
                TabSidebarDemo()
            }
        case "sceneGeometry":
            SceneGeometryDemo()
        case "verticalBars":
            DemoLauncher(embedsInNavigationStack: false) {
                VerticalBarsDemo()
            }
        case "axisBehavior":
            DemoLauncher {
                AxisBehaviorDemo()
            }
        case "overflow":
            DemoLauncher(embedsInNavigationStack: false) {
                OverflowDemo()
            }
        case "verticalBarEdge":
            DemoLauncher {
                VerticalBarEdgeDemo()
            }
        case "sheetBars":
            DemoLauncher {
                SheetBarsDemo()
            }
        case "reservedRegions":
            DemoLauncher(embedsInNavigationStack: false) {
                ReservedRegionsDemo()
            }
        case "splitArrangement":
            DemoLauncher {
                ArrangementDemo(initialStyle: .split)
            }
        case "overlayArrangement":
            DemoLauncher {
                ArrangementDemo(initialStyle: .overlay)
            }
        case "hingeSwiftUI":
            HingeSwiftUIDemo()
        case "multiWindow":
            MultiWindowDemo()
        case "cameraAccessory":
            DemoLauncher(embedsInNavigationStack: false) {
                CameraAccessoryDemo()
            }
        case "virtualFrontCamera":
            FrontCamerasDemo()
        case "directionCoordinator":
            DirectionCoordinatorDemo()
        default:
            ContentUnavailableView("Coming soon", systemImage: "hammer")
        }
    }
}
