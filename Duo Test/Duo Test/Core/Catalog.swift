import Foundation

/// Static content for the showcase: every API demo, every use case, and the readiness checklist.
enum Catalog {
    static let apis: [APIEntry] = {
        let apis: [APIEntry] = [
            // MARK: Adaptive Layout
            APIEntry(
                id: "sizeClasses", area: .layout, title: "Size Classes",
                summary: "Lay out for compact and regular widths instead of devices or poses; the outer display is compact, the inner display is regular.",
                swiftUISymbols: ["horizontalSizeClass", "verticalSizeClass", "onGeometryChange"],
                frameworkSymbols: [],
                talk: .prepare, deviceOnly: false),
            APIEntry(
                id: "asymmetricSafeArea", area: .layout, title: "Asymmetric Safe Areas",
                summary: "Vertical bars inset only one edge, so read each side's inset on its own and keep backgrounds full bleed.",
                swiftUISymbols: ["safeAreaInsets", "ignoresSafeArea"],
                frameworkSymbols: [],
                talk: .prepare, deviceOnly: false),
            APIEntry(
                id: "concentricity", area: .layout, title: "Concentric Corners",
                summary: "Match the new screen shapes by deriving corner radii from the container instead of hard-coding them.",
                swiftUISymbols: ["ConcentricRectangle"],
                frameworkSymbols: [],
                talk: .prepare, deviceOnly: false),
            APIEntry(
                id: "tabSidebar", area: .layout, title: "Tab Bar as Sidebar",
                summary: "Information-dense apps can turn their tab bar into a sidebar when the inner display has room.",
                swiftUISymbols: ["defaultTabBarPlacement(.sidebar)"],
                frameworkSymbols: [],
                talk: .prepare, deviceOnly: false),
            APIEntry(
                id: "sceneGeometry", area: .layout, title: "Scene Geometry",
                summary: "Size from the scene and its views, re-reading on every layout pass because a fold can resize the app mid-session.",
                swiftUISymbols: ["GeometryReader"],
                frameworkSymbols: [],
                talk: .prepare, deviceOnly: false),

            // MARK: Vertical Bars
            APIEntry(
                id: "verticalBars", area: .bars, title: "Vertical Bars",
                summary: "Navigation, toolbar, and tab items share one vertical region; place Close first, then the prominent action, then the rest by group.",
                swiftUISymbols: ["ToolbarItem(placement:)", ".cancellationAction", ".topBarPinnedTrailing"],
                frameworkSymbols: [],
                talk: .raiseTheBar, deviceOnly: false),
            APIEntry(
                id: "axisBehavior", area: .bars, title: "Axis Behavior",
                summary: "Decide which items may go vertical: symbol items move, text items stay horizontal, and custom views opt in.",
                swiftUISymbols: ["axisBehavior(_:)", "badge"],
                frameworkSymbols: [],
                talk: .raiseTheBar, deviceOnly: false),
            APIEntry(
                id: "overflow", area: .bars, title: "Overflow & Priority",
                summary: "Choose whether the toolbar or the tab bar compresses first, and rank items so frequent actions stay visible longest.",
                swiftUISymbols: ["ToolbarOverflowMenu", "visibilityPriority", "toolbarVerticalCompressionBehavior"],
                frameworkSymbols: [],
                talk: .raiseTheBar, deviceOnly: false),
            APIEntry(
                id: "verticalBarEdge", area: .bars, title: "Vertical Bar Edge",
                summary: "Read which edge holds the vertical bar to adapt custom views, and extend hero art underneath it.",
                swiftUISymbols: ["toolbarVerticalEdge", "backgroundExtensionEffect"],
                frameworkSymbols: [],
                talk: .raiseTheBar, deviceOnly: false),
            APIEntry(
                id: "sheetBars", area: .bars, title: "Sheets & Opting Out",
                summary: "Sheets get vertical bars on the outer display; disable them for single-action sheets or bottom-heavy layouts.",
                swiftUISymbols: ["toolbarVerticalBehavior(.disabled)", "presentationPlacement"],
                frameworkSymbols: [],
                talk: .raiseTheBar, deviceOnly: false),

            // MARK: Reserved Regions
            APIEntry(
                id: "reservedRegions", area: .regions, title: "Reserved Regions",
                summary: "Query the fold (a division) and the cameras (occlusions) in your view's coordinates and move custom content clear of them.",
                swiftUISymbols: ["reservedRegions(kind:options:)", "ReservedRegion"],
                frameworkSymbols: [],
                talk: .strikeAPose, deviceOnly: false),

            // MARK: Arrangements
            APIEntry(
                id: "splitArrangement", area: .arrangements, title: "Split Arrangement",
                summary: "Two views side by side or stacked by aspect ratio, resized automatically around the fold.",
                swiftUISymbols: ["ArrangementView", ".split.axes(_:)"],
                frameworkSymbols: [],
                talk: .strikeAPose, deviceOnly: false),
            APIEntry(
                id: "overlayArrangement", area: .arrangements, title: "Overlay Arrangement",
                summary: "Layer a foreground over a background on a flat display, then split them across the fold.",
                swiftUISymbols: [".overlay", "overlayArrangementZIndex"],
                frameworkSymbols: [],
                talk: .strikeAPose, deviceOnly: false),

            // MARK: Hinge
            APIEntry(
                id: "hingeSwiftUI", area: .hinge, title: "Hinge",
                summary: "Observe the hinge status and angle to drive interactions and effects, not layout.",
                swiftUISymbols: ["onHingeChange", "DeviceHinge"],
                frameworkSymbols: [],
                talk: .multipleDisplays, deviceOnly: false),

            // MARK: Scenes & Displays
            APIEntry(
                id: "multiWindow", area: .scenes, title: "Multiple Windows",
                summary: "iPhone Duo supports multiple scenes, but only the inner display can create new windows.",
                swiftUISymbols: ["openWindow", "WindowGroup(id:)"],
                frameworkSymbols: [],
                talk: .multipleDisplays, deviceOnly: false),
            APIEntry(
                id: "cameraAccessory", area: .scenes, title: "Camera Capture Accessory",
                summary: "Show extra UI on the outer display while the camera UI runs full screen on the inner display.",
                swiftUISymbols: ["sceneAccessory", "CameraCaptureAccessory", "onAvailabilityChange"],
                frameworkSymbols: [],
                talk: .multipleDisplays, deviceOnly: true),

            // MARK: Camera
            APIEntry(
                id: "virtualFrontCamera", area: .camera, title: "Front Cameras",
                summary: "The Virtual Front Camera switches between the inner and outer ultra wide cameras for you; pick a physical one for full capabilities.",
                swiftUISymbols: [],
                frameworkSymbols: ["AVCaptureDevice.DiscoverySession", ".builtInOuterUltraWideCamera", ".builtInInnerUltraWideCamera"],
                talk: .camera, deviceOnly: true),
            APIEntry(
                id: "directionCoordinator", area: .camera, title: "Direction Coordinator",
                summary: "Know which camera faces the person relative to your view, and switch as the device opens, closes, or flips.",
                swiftUISymbols: [],
                frameworkSymbols: ["AVCaptureDeviceDirectionCoordinator", "dynamicAspectRatio", "isCameraSensorOrientationCompensationEnabled"],
                talk: .camera, deviceOnly: true),
        ]
        assert(Set(apis.map(\.id)).count == apis.count, "Duplicate APIEntry id")
        return apis
    }()

    static let useCases: [UseCase] = {
        let useCases: [UseCase] = [
            UseCase(
                id: "mail", title: "Mail Continuity",
                summary: "Inbox on the outer display, inbox plus message on the inner display, same selection either way.",
                systemImage: "envelope", poses: [.closed, .fullyOpen],
                apiIDs: ["sizeClasses", "verticalBars", "tabSidebar"]),
            UseCase(
                id: "podcast", title: "Podcast + Transcript",
                summary: "Now Playing beside its transcript, splitting cleanly when the device folds like a book.",
                systemImage: "waveform", poses: [.fullyOpen, .partiallyOpen],
                apiIDs: ["splitArrangement", "overflow"]),
            UseCase(
                id: "tabletopVideo", title: "Tabletop Video",
                summary: "Set it down like a laptop: video on top, a stable row of controls on the bottom.",
                systemImage: "play.rectangle", poses: [.partiallyOpen],
                apiIDs: ["overlayArrangement", "reservedRegions"]),
            UseCase(
                id: "airGuitar", title: "Air Guitar Whammy",
                summary: "Fold the device to bend the pitch, like a whammy bar.",
                systemImage: "guitars", poses: [.partiallyOpen],
                apiIDs: ["hingeSwiftUI"]),
            UseCase(
                id: "teleprompter", title: "Teleprompter Rehearsal",
                summary: "Record on the inner display while your script scrolls on the outer display.",
                systemImage: "text.viewfinder", poses: [.fullyOpen],
                apiIDs: ["cameraAccessory", "directionCoordinator"]),
            UseCase(
                id: "photoGrid", title: "Fold-Aware Photo Grid",
                summary: "An even number of columns with extra space at the hinge, so no photo sits in the fold.",
                systemImage: "photo.on.rectangle", poses: [.fullyOpen, .partiallyOpen],
                apiIDs: ["reservedRegions", "asymmetricSafeArea"]),
            UseCase(
                id: "calculator", title: "Full-Width Calculator",
                summary: "A single-page, bottom-heavy layout that opts out of vertical bars to use the whole width.",
                systemImage: "plus.forwardslash.minus", poses: [.closed],
                apiIDs: ["sheetBars", "verticalBarEdge"]),
        ]
        let ids = Set(apis.map(\.id))
        assert(useCases.allSatisfy { $0.apiIDs.allSatisfy(ids.contains) }, "UseCase references an unknown APIEntry id")
        return useCases
    }()

    static let readiness: [ReadinessItem] = [
        ReadinessItem(id: "appResizabilitySkill", step: 1, title: "Run the App Resizability skill",
                      avoid: "Auditing every file by hand",
                      prefer: "Ask Xcode “get my app ready for iPhone Duo”, or xcrun agent skills export"),
        ReadinessItem(id: "mainScreen", step: 2, title: "Size from the view or window",
                      avoid: "UIScreen.main.bounds",
                      prefer: "view.bounds · GeometryReader · onGeometryChange"),
        ReadinessItem(id: "displayScale", step: 2, title: "Get scale from traits",
                      avoid: "UIScreen.main.scale",
                      prefer: "traitCollection.displayScale · @Environment(\\.displayScale)"),
        ReadinessItem(id: "windowFromScene", step: 2, title: "Create windows from a scene",
                      avoid: "UIWindow(frame: UIScreen.main.bounds)",
                      prefer: "UIWindow(windowScene:)"),
        ReadinessItem(id: "orientation", step: 2, title: "Don't lay out by orientation",
                      avoid: "interfaceOrientation · UIDevice.current.orientation",
                      prefer: "Compare the width and height of the space you have"),
        ReadinessItem(id: "idiom", step: 2, title: "Don't lay out by idiom",
                      avoid: "userInterfaceIdiom == .pad",
                      prefer: "Size classes or available space"),
        ReadinessItem(id: "fixedSizes", step: 2, title: "Remove device-size checks",
                      avoid: "bounds.height == 844",
                      prefer: "Size relative to the container"),
        ReadinessItem(id: "fullBleed", step: 2, title: "Check full-bleed media",
                      avoid: ".aspectRatio(contentMode: .fill) everywhere",
                      prefer: "Choose fill or fit by size class or aspect ratio"),
        ReadinessItem(id: "testResizing", step: 3, title: "Test resizing",
                      avoid: "Testing only one display",
                      prefer: "iPhone Duo simulator: open, close, rotate, fold, Split View left and right, pinned PiP"),
    ]

    /// The readiness checklist from docs/iphone-duo-tech-talks-notes.md.
    static let duoChecklist: [String] = [
        "Build dengan Xcode 27.1 / iOS 27.1 SDK; tes di simulator iPhone Duo (open/close/rotate/fold, Split View kiri & kanan, PiP).",
        "Hapus `UIScreen.main`, cek idiom/orientation untuk layout → size class/trait/scene.",
        "Safe area & margin asimetris; foreground dalam safe area.",
        "Bar dari container sistem; semua item punya title + icon; urutan atas→bawah benar.",
        "`AxisBehavior` untuk item custom; badge ganti teks hitungan.",
        "`visibilityPriority`, `toolbarCompressionBehavior`, overflow menu sistem.",
        "Inner display: split / 2 kolom / sidebar.",
        "Audit layout centered → displacement / `ArrangementView` / `reservedRegion`.",
        "Fitur sama di semua pose.",
        "Multi-scene: tangani window hanya di inner.",
        "Kamera: virtual front vs individual + direction coordinator; rotation coordinator.",
        "Jalankan skill App Resizability.",
    ]

    static func api(id: String) -> APIEntry? {
        apis.first { $0.id == id }
    }
}
