# iPhone Duo Developer Guide

Nov 8, 2026 · William Santoso

To get ready for iPhone Duo: build with Xcode 27.1, drive layout from size classes and safe areas, use system containers, then handle the fold with reserved regions or `ArrangementView`. Everything here comes from Apple's six tech talks and the workshop deck "Develop App for iPhone Duo using SwiftUI". Most APIs need the **iOS 27.1 SDK** and are SwiftUI-first with a UIKit twin. Code is adapted from the talks' listings, so verify signatures against the docs before shipping.

**Start from the problem, then pick the API**

| Problem | API |
| --- | --- |
| Layout must change between displays | Size class + safe area |
| Bars and navigation move to the side | System containers + `.toolbar` |
| Manual UI collides with fold or camera | `reservedRegions(kind:)` |
| Two related views must rearrange | `ArrangementView` |
| An effect follows the fold angle | `onHingeChange` / `UIHingeInteraction` |
| Extra UI on outer during capture | `CameraCaptureAccessory` |
| Need the camera that faces the user | `AVCaptureDeviceDirectionCoordinator` |

Each API has one job: the hinge drives effects, regions and arrangements drive layout.

## Device model

Duo has two displays, and the hardware position decides where bars and safe areas land.

| State | Traits | Bar position |
| --- | --- | --- |
| Outer display (closed) | Wider and shorter than a regular iPhone; camera, status bar and Dynamic Island on the right side | Right side |
| Inner display, landscape | Largest iPhone screen | Side |
| Inner display, portrait | The only pose with horizontal bars | Top and bottom |
| Split View 50/50 | Via the home gesture; an app on the left moves its bars to the left edge; only on the unfolded inner display in landscape | Outer edge |

- **Poses:** book (half folded), laptop or tabletop (on a desk, lower screen for controls), tent (standing on its edges). The workshop deck lists six to test: folded, tent, and fully or partially unfolded in landscape and in portrait.
- **Fold:** when half folded, the system moves interactive elements away from the center curve. Scrolling content may cross the fold; buttons may not. In the workshop simulator, the inner display splits about 40:60 off-center when fully open and 50:50 at the hinge when partially open.
- **PiP:** can be pinned to the top. The app below resizes vertically, and grows to half the screen when folded.
- **Orientation:** the inner display ignores supported interface orientations; the app is scaled. Rotation lock works only on the outer display; the inner display always rotates, even for a portrait-only app.

## SDK and tooling

Build with **Xcode 27.1 / iOS 27.1 SDK** to get the full-screen Duo layout. What the app gets depends on the SDK it links.

**Requirements:** macOS Tahoe 26.6 or later, Xcode 27.1 or later, and the iOS 27.1 Simulator or later.

▶ [Prepare — Build with the latest SDK (0:30)](https://developer.apple.com/videos/play/tech-talks/111461/?time=30) · [Get started in Xcode (1:17)](https://developer.apple.com/videos/play/tech-talks/111461/?time=77) · [App Resizability skill (9:12)](https://developer.apple.com/videos/play/tech-talks/111461/?time=552)

| Linked SDK | Behavior on iPhone Duo |
| --- | --- |
| Pre-iOS 27 | Runs; outer uses only the area left of the status bar and camera; inner keeps a familiar size and aspect (letterboxed), with black bars around a centered app, like an iPhone app on iPad |
| iOS 27 | Extends left of the status bar on the inner display; with resizability support the inner display is nearly full screen, while the outer keeps a black bar on the right |
| iOS 27.1 | Edge to edge; standard nav and toolbar buttons lay out vertically |

- **Device Hub simulator:** pick iPhone Duo, then use the bottom controls to open, close, rotate and fold.
- **Split View testing:** in Device Hub, drag the app by the home indicator to either side of the inner display.
- **App Resizability skill** (Xcode 27.1): formerly the app modernization skill; audits SwiftUI and UIKit for resizability and Duo issues.
- `UIRequiresFullScreen` is still honored, but the app still resizes on open and close.
- **Agent skills** (Xcode 27): the bundled skills include `swiftui-specialist`, `swiftui-whats-new-27`, `uikit-app-modernization`, `app-intents-specialist`, `modernize-tests`, `device-interaction` and the accessibility and translation skills. Run `xcrun agent skills export` to use them outside Xcode.

## Design principles

An app's functions and hierarchy must stay the same in every pose; only the arrangement changes. The tabletop pose may have its own layout (media on top, controls below), as long as the controls stay complete.

▶ [Design — Design principles, split view and PiP (0:28)](https://developer.apple.com/videos/play/tech-talks/111466/?time=28) · [Adapting your design (3:42)](https://developer.apple.com/videos/play/tech-talks/111466/?time=222) · [Positioning controls (5:07)](https://developer.apple.com/videos/play/tech-talks/111466/?time=307)

- **Design for size classes,** not poses or devices. Avoid fixed widths, breakpoints and screen-specific metrics.
- **The inner display is not a stretched iPhone.** Use split view, a two-column layout, or a tab bar that becomes a sidebar for information-dense apps.
- **Centered content on the outer display** usually needs an offset; it comes for free if you align to the horizontal safe area insets. Full-screen centering is only for immersive, non-scrolling UI that controls don't cover.
- **Use system components.** Popovers, context menus, alerts, menus and toolbar buttons avoid the fold automatically. Sheets shift off the fold when half folded.
- **Sheets:** on the outer display, buttons can go vertical. On the inner display, sheets are centered with horizontal bars.
- **Don't assume the idiom:** iPhone Duo is a phone, so never branch layout on `userInterfaceIdiom`.
- **Use as many native components as you can,** and never read `UIScreen.main.bounds`.
- **Don't be afraid of asymmetric design;** the outer display and Split View are not centered.

▶ [Design — Outer display offsets (6:33)](https://developer.apple.com/videos/play/tech-talks/111466/?time=393) · [Designing for the inner display (7:34)](https://developer.apple.com/videos/play/tech-talks/111466/?time=454) · [Sheet behavior (8:36)](https://developer.apple.com/videos/play/tech-talks/111466/?time=516) · [Fold avoidance (9:28)](https://developer.apple.com/videos/play/tech-talks/111466/?time=568)

## Layout foundations

Drive layout from size classes and safe areas; never from orientation, idiom or `UIScreen.main`.

| Display / pose | Horizontal | Vertical |
| --- | --- | --- |
| Outer, portrait | compact | regular |
| Outer, landscape | compact | compact |
| Inner, any pose | regular | regular |

**Size classes**

▶ [Prepare — Use size classes (2:46)](https://developer.apple.com/videos/play/tech-talks/111461/?time=166) · [code (2:59)](https://developer.apple.com/videos/play/tech-talks/111461/?time=179)

```swift
struct LibraryView: View {
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            TwoColumnLibrary()   // inner display
        } else {
            StackedLibrary()     // outer display
        }
    }
}
// UIKit: traitCollection.horizontalSizeClass / .verticalSizeClass
```

**Screen access** — `UIScreen.main` is ambiguous on two displays and will be deprecated. Use the environment, trait collection or scene bounds.

▶ [Prepare — Avoid screen assumptions (3:57)](https://developer.apple.com/videos/play/tech-talks/111461/?time=237) · [window scene code (4:16)](https://developer.apple.com/videos/play/tech-talks/111461/?time=256) · [replace main screen (9:25)](https://developer.apple.com/videos/play/tech-talks/111461/?time=565)

```swift
// Before
let scale = UIScreen.main.scale
// After
let scale = traitCollection.displayScale
let screen = view.window?.windowScene?.screen   // only if you truly need it
```

**Concentric corners** — updated for Duo's screen shapes.

▶ [Prepare — Concentricity (4:30)](https://developer.apple.com/videos/play/tech-talks/111461/?time=270)

```swift
ConcentricRectangle()
    .fill(.green)
    .padding(8)
    .ignoresSafeArea()
// UIKit: UICornerConfiguration
```

**Sidebar tabs on the inner display**

▶ [Prepare — Sidebar on the inner display (5:44)](https://developer.apple.com/videos/play/tech-talks/111461/?time=344)

```swift
TabView { /* tabs */ }
    .defaultTabBarPlacement(.sidebar)
// UIKit: tabBarController.sidebar.preferredPlacement = .sidebar
```

**Asymmetric safe areas** — vertical bars can sit on either edge (landscape, Split View), so the left inset may not equal the right. Handle each side independently. Horizontal bars add top and bottom insets; vertical bars add leading and trailing insets.

▶ [Prepare — Respect safe areas (6:06)](https://developer.apple.com/videos/play/tech-talks/111461/?time=366) · [asymmetric insets code (7:30)](https://developer.apple.com/videos/play/tech-talks/111461/?time=450)

```swift
// Wrong: assumes left == right
let width = view.bounds.width - view.safeAreaInsets.left * 2
// Right
let width = view.bounds.inset(by: view.safeAreaInsets).width

// Foreground inside, background full bleed
foreground.frame = view.bounds.inset(by: view.safeAreaInsets)
background.frame = view.bounds          // SwiftUI: .ignoresSafeArea()
```

**Standard containers** — adapt for free.

▶ [Prepare — Adopt standard navigation (5:01)](https://developer.apple.com/videos/play/tech-talks/111461/?time=301)

- `NavigationSplitView` / `UISplitViewController`: collapse to a stack when closed; tiled or overlay columns when open.
- `TabView` / `UITabBarController`: vertical tabs when needed, sidebar on the inner display.
- Sheets, popovers, context menus and alerts adapt too.

## Vertical bars

Bars go vertical automatically once you link the 27.1 SDK and use container-managed bars; custom `UIToolbar` / `UINavigationBar` / `UITabBar` content is left out. Items with a symbol go vertical and text-only items stay horizontal, so always give items both a title and an image.

▶ [Raise the bar — Why bars move to the side (0:28)](https://developer.apple.com/videos/play/tech-talks/111462/?time=28) · [Understand the shared bar region (3:09)](https://developer.apple.com/videos/play/tech-talks/111462/?time=189) · [Prepare toolbar content (5:56)](https://developer.apple.com/videos/play/tech-talks/111462/?time=356)

Picture the nav bar, toolbar and tab bar rotated 90° into one shared vertical stack. Top toolbars go to the top of the stack, bottom toolbars to the bottom, and the tab bar stays at the bottom.

**Toolbar labels** — build items from `Label`, so SwiftUI can show the icon in a vertical bar and the title elsewhere. Keep title-only items and custom views that show both text and an image to a minimum.

**Opt in via containers**

▶ [Raise the bar — Opt in to vertical bars (2:00)](https://developer.apple.com/videos/play/tech-talks/111462/?time=120) · [SwiftUI code (2:24)](https://developer.apple.com/videos/play/tech-talks/111462/?time=144) · [UIKit code (2:39)](https://developer.apple.com/videos/play/tech-talks/111462/?time=159)

```swift
NavigationStack {
    ContentView()
        .toolbar {
            ToolbarItem(placement: .bottomBar) { ShareButton() }
        }
}
// UIKit: set toolbarItems on a VC inside UINavigationController / UITabBarController
```

**Order, top to bottom** — back or close, then the prominent action, then the rest by group. A vertical spacer separates the top and bottom groups.

▶ [Raise the bar — Order items in a vertical bar (4:29)](https://developer.apple.com/videos/play/tech-talks/111462/?time=269) · [back/close code (5:00)](https://developer.apple.com/videos/play/tech-talks/111462/?time=300) · [prominent action code (5:24)](https://developer.apple.com/videos/play/tech-talks/111462/?time=324)

```swift
.toolbar {
    ToolbarItem(placement: .cancellationAction) { Button("Close", systemImage: "xmark") { dismiss() } }
    ToolbarItem(placement: .topBarPinnedTrailing) { Button("Done", systemImage: "checkmark") { save() } }
}
// UIKit
navigationItem.leftItemsSupplementBackButton = false
navigationItem.leadingItemGroups = [UIBarButtonItemGroup(/* close */)]
navigationItem.pinnedTrailingGroup = UIBarButtonItemGroup(/* done */)
```

**Axis control with `axisBehavior`** — `.horizontalOnly` for items that morph between symbol and text, such as a custom Select; `.verticalPreferred` for custom views with a vertical form. The system Edit button is already horizontal.

▶ [Raise the bar — Control the axis of an item (8:00)](https://developer.apple.com/videos/play/tech-talks/111462/?time=480) · [verticalPreferred (8:08)](https://developer.apple.com/videos/play/tech-talks/111462/?time=488) · [horizontalOnly (8:36)](https://developer.apple.com/videos/play/tech-talks/111462/?time=516)

```swift
.toolbar {
    ToolbarItem { CompassView() }
        .axisBehavior(.verticalPreferred)    // custom view that fits a vertical bar
    ToolbarItem { SelectOrDoneButton() }
        .axisBehavior(.horizontalOnly)       // morphs symbol <-> text
}
// UIKit: item.axisBehavior = .verticalPreferred / .horizontalOnly
```

**Badges instead of inline counts** — leave text that carries key information, such as a total price, horizontal.

▶ [Raise the bar — Prefer symbol-only items (9:00)](https://developer.apple.com/videos/play/tech-talks/111462/?time=540) · [badge code (9:27)](https://developer.apple.com/videos/play/tech-talks/111462/?time=567)

```swift
ToolbarItem { InboxButton().badge(7) }
// UIKit: item.badge = .count(7)
```

**Detect a vertical bar in custom views** — custom views must fit the fixed width or have a vertical layout, and stay legible with Reduce Transparency.

▶ [Raise the bar — Adapt custom views (10:07)](https://developer.apple.com/videos/play/tech-talks/111462/?time=607) · [toolbarVerticalEdge code (10:36)](https://developer.apple.com/videos/play/tech-talks/111462/?time=636)

```swift
struct ActionPanel: View {
    @Environment(\.toolbarVerticalEdge) private var edge   // nil when bars can't be vertical

    var body: some View {
        if edge != nil { CompactPanel() } else { FullPanel() }
    }
}
// UIKit: traitCollection.verticalBarEdge
```

**Overflow** — common on outer landscape, with the keyboard up, and with PiP. By default the toolbar compresses first, which suits navigation apps; task-oriented apps should compress the tab bar first. Items overflow from bottom to top, so give high priority to frequent actions and badged items. Keep the ellipsis for overflow only.

▶ [Raise the bar — Manage the overflow menu (11:40)](https://developer.apple.com/videos/play/tech-talks/111462/?time=700) · [compression code (12:23)](https://developer.apple.com/videos/play/tech-talks/111462/?time=743) · [overflow menu code (12:43)](https://developer.apple.com/videos/play/tech-talks/111462/?time=763) · [Prioritize item visibility (13:10)](https://developer.apple.com/videos/play/tech-talks/111462/?time=790)

```swift
Tab("Recents", systemImage: "clock") {
    ContentView()
        .toolbarVerticalCompressionBehavior(.prefersToolbarItems) // tab bar compresses first
        .toolbar {
            ToolbarItem { Button("Compose", systemImage: "square.and.pencil") { } }
                .visibilityPriority(.high)
            ToolbarOverflowMenu {
                Button("Scan") { }
                Button("Connect") { }
            }
        }
}
// UIKit
navigationItem.verticalBarCompressionBehavior = .prefersBarItems
item.visibilityPriority = .high
navigationItem.additionalOverflowItems = UIDeferredMenuElement { provider in
    provider(self.overflowItems())
}
```

**Opt out** — for bottom-heavy single-page apps (calculator style) or sheets with one button.

▶ [Raise the bar — When to opt out (14:21)](https://developer.apple.com/videos/play/tech-talks/111462/?time=861) · [code (14:47)](https://developer.apple.com/videos/play/tech-talks/111462/?time=887)

```swift
NavigationStack {
    CalculatorView().toolbarVerticalBehavior(.disabled)
}
// UIKit
override var preferredVerticalBarBehavior: UIVerticalBarBehavior { .disabled }
```

- Only containers touching a display edge get a vertical bar. In split views that means the detail column only; inspectors get none.
- Inner sheets with `preferredPlacement`: on the left, no vertical bar; on the right, a vertical bar.
- Bars are tied to the hardware, so they stay on the same side in RTL languages.
- Flexible spacers collapse to zero in vertical bars; fixed spacers keep their minimum.
- Keyboard accessory bars stay attached to the keyboard.

## Reserved regions and displacement (iOS 27.1)

Reserved regions let manually laid-out UI avoid the hinge and the inner FaceTime camera. Only active regions are returned unless you pass `.includeInactive`.

▶ [Strike a pose — Reserved regions on iPhone Duo (0:27)](https://developer.apple.com/videos/play/tech-talks/111463/?time=27) · [Query reserved regions (6:39)](https://developer.apple.com/videos/play/tech-talks/111463/?time=399) · [Division and occlusion regions (7:50)](https://developer.apple.com/videos/play/tech-talks/111463/?time=470) · [Prepare — Use reserved regions (8:08)](https://developer.apple.com/videos/play/tech-talks/111461/?time=488)

| Kind | Hardware | Active when |
| --- | --- | --- |
| `.division` | Hinge / fold | Device partially folded (zero width when flat) |
| `.occlusion` | Inner FaceTime camera | Camera in use |

```swift
GeometryReader { proxy in
    let folds = proxy.reservedRegions(kind: .division).map(\.frame)      // hinge, while partially folded
    let cameras = proxy.reservedRegions(kind: .occlusion).map(\.frame)   // inner camera, while in use

    GridContent(avoiding: folds + cameras)
}
```

**SwiftUI** — on `GeometryProxy`, from `GeometryReader` or `onGeometryChange`. Inactive regions help with high-level decisions, such as choosing an even column count.

▶ [Strike a pose — SwiftUI query (6:46)](https://developer.apple.com/videos/play/tech-talks/111463/?time=406) · [includeInactive (7:22)](https://developer.apple.com/videos/play/tech-talks/111463/?time=442) · [occlusion (8:07)](https://developer.apple.com/videos/play/tech-talks/111463/?time=487)

```swift
struct PhotoGrid: View {
    @State private var foldFrames: [CGRect] = []

    var body: some View {
        GridContent(avoiding: foldFrames)
            .onGeometryChange(for: [CGRect].self) { proxy in
                proxy.reservedRegions(kind: .division).map(\.frame)
            } action: { foldFrames = $0 }
    }
}

// Design decisions that shouldn't flip as the hinge moves
GeometryReader { proxy in
    let hasFold = !proxy.reservedRegions(kind: .division,
                                         options: .includeInactive).isEmpty
    Grid(columns: hasFold ? 4 : 3)   // prefer even columns when a fold exists
}
```

**UIKit** — on `UIView`

▶ [Strike a pose — UIKit query (7:03)](https://developer.apple.com/videos/play/tech-talks/111463/?time=423)

```swift
override func layoutSubviews() {
    super.layoutSubviews()
    let folds = reservedRegions(kind: .division).map(\.frame)
    let camera = reservedRegions(kind: .occlusion).map(\.frame)
    layoutControls(avoiding: folds + camera)
}
```

**Displacement** moves or resizes existing elements to fit the space when folded.

▶ [Strike a pose — Displacement patterns (2:26)](https://developer.apple.com/videos/play/tech-talks/111463/?time=146) · [Choose where content moves (4:00)](https://developer.apple.com/videos/play/tech-talks/111463/?time=240) · [Adapt content to its new region (5:12)](https://developer.apple.com/videos/play/tech-talks/111463/?time=312)

- Independent elements move on their own; related elements move together, such as a photo and its context menu. Don't move them far from their source.
- Continuous scrolling content (articles, feeds, lists) is not displaced.
- Purpose picks the region. In book pose, alerts go trailing, near the outer display. In tabletop, information goes to the upper region and tap controls to the lower one.
- Stay contextual: a search field follows the view it searches.
- Grids keep their outer margins and widen the gap around the hinge.
- `ReservedRegion` / `UIViewReservedRegion` suit custom bars or edge-to-edge UI that must not collide with system UI.

## Arrangements (iOS 27.1)

`ArrangementView` lays out a primary and a secondary view from size class, aspect ratio and active fold regions. It sits between the navigation container and the content container.

▶ [Strike a pose — Introducing arrangements (9:20)](https://developer.apple.com/videos/play/tech-talks/111463/?time=560) · [Build with ArrangementView (11:17)](https://developer.apple.com/videos/play/tech-talks/111463/?time=677) · [Choose between arrangements (14:39)](https://developer.apple.com/videos/play/tech-talks/111463/?time=879)

| Style | View relationship | Already using | Behavior |
| --- | --- | --- | --- |
| `.split` (default) | Main/detail; neither may be obscured | `HStack` / `VStack` | Side by side on the long axis; if it can't split on the primary axis, only the primary view shows |
| `.overlay` | Foreground/background; content may scroll under controls | `ZStack` | Stacked when flat, side by side when folded |

**Split** — restrict the axis with `.axes`.

▶ [Strike a pose — Configure the split arrangement (12:00)](https://developer.apple.com/videos/play/tech-talks/111463/?time=720) · [restrict axes (12:41)](https://developer.apple.com/videos/play/tech-talks/111463/?time=761)

```swift
NavigationStack {
    ArrangementView {
        PlayerView()
    } secondary: {
        UpNextView()
    }
    .arrangementViewStyle(.split.axes(.horizontal))
}
```

**Overlay** — read the z-index to collapse or expand.

▶ [Strike a pose — Use the overlay arrangement (13:21)](https://developer.apple.com/videos/play/tech-talks/111463/?time=801) · [Z index code (14:07)](https://developer.apple.com/videos/play/tech-talks/111463/?time=847)

```swift
ArrangementView {
    UpNextView()
} secondary: {
    PlayerView()
}
.arrangementViewStyle(.overlay)

struct UpNextView: View {
    @Environment(\.overlayArrangementZIndex) private var zIndex: Int

    var body: some View {
        UpNextList(collapsed: zIndex > 0)
    }
}
```

**UIKit**

▶ [Strike a pose — UIArrangementViewController (11:26)](https://developer.apple.com/videos/play/tech-talks/111463/?time=686) · [updateArrangement (13:07)](https://developer.apple.com/videos/play/tech-talks/111463/?time=787) · [state(for:) z index (14:21)](https://developer.apple.com/videos/play/tech-talks/111463/?time=861)

```swift
let arrangementVC = UIArrangementViewController()
arrangementVC.setViewController(PlayerViewController(), for: .primary)
arrangementVC.setViewController(UpNextViewController(), for: .secondary)
arrangementVC.updateArrangement(.split.axes(.horizontal))
let nav = UINavigationController(rootViewController: arrangementVC)

// Overlay z-index
let collapsed = (arrangementVC.state(for: .primary)?.zIndex ?? 0) > 0
```

- Don't put `NavigationSplitView` or any other navigation container inside an `ArrangementView`.
- Don't put an `ArrangementView` inside `List` or `ScrollView`.

▶ [Strike a pose — When not to use an arrangement (16:09)](https://developer.apple.com/videos/play/tech-talks/111463/?time=969)

## Hinge, scenes and scene accessories

Use hinge data for live effects and interactions, never for layout. Layout uses regions and arrangements.

**Hinge** — `onHingeChange` / `UIHingeInteraction`. Status is `.closed`, `.partiallyOpen` or `.fullyOpen`, plus a continuous `angle`. A nil hinge means the device has none. Reset state when you stop reading the angle.

▶ [Leverage — Respond to the hinge (0:49)](https://developer.apple.com/videos/play/tech-talks/111464/?time=49) · [pitch bend walkthrough (1:18)](https://developer.apple.com/videos/play/tech-talks/111464/?time=78) · [hinge vs. layout APIs (2:35)](https://developer.apple.com/videos/play/tech-talks/111464/?time=155)

```swift
struct InstrumentView: View {
    @State private var pitchBend = 0.0   // 0...1

    var body: some View {
        GuitarView(pitchBend: pitchBend)
            .onHingeChange { _, context in
                if let hinge = context.hinge, hinge.status == .partiallyOpen {
                    pitchBend = normalized(hinge.angle)
                } else {
                    pitchBend = 0
                }
            }
    }

    private func normalized(_ angle: Angle) -> Double { /* map degrees to 0...1 */ 0 }
}
```

**Multiple scenes** — Duo is the first iPhone with multi-window, and iPad support carries over. New windows can only open on the inner display. Handle scene-request errors, or use `UIWindowSceneActivationAction`, which hides itself when windows aren't available.

▶ [Leverage — Support multiple scenes (3:38)](https://developer.apple.com/videos/play/tech-talks/111464/?time=218)

```swift
let newWindow = UIWindowSceneActivationAction { _ in
    UIWindowScene.ActivationConfiguration(userActivity: NSUserActivity(activityType: "com.app.detail"))
}
// Add to a context menu or toolbar; hidden automatically on the outer display
```

**`CameraCaptureAccessory`** — UI on the outer display while the camera UI stays on the inner display, such as a teleprompter. It requires the app to be full screen on the inner display with an active capture session. Register it on the camera view. The system controls availability (on by default, can be toggled), so observe it with `onAvailabilityChange`.

▶ [Leverage — Scene accessories (4:22)](https://developer.apple.com/videos/play/tech-talks/111464/?time=262) · [Camera capture accessory (5:00)](https://developer.apple.com/videos/play/tech-talks/111464/?time=300) · [Teleprompter build (5:34)](https://developer.apple.com/videos/play/tech-talks/111464/?time=334) · [availability code (6:25)](https://developer.apple.com/videos/play/tech-talks/111464/?time=385)

```swift
struct CameraRootView: View {
    @State private var model = TeleprompterModel()

    var body: some View {
        CameraView(model: model)
            .sceneAccessory {
                CameraCaptureAccessory(isEnabled: $model.isEnabled) {
                    TeleprompterView(model: model)
                }
                .onAvailabilityChange { model.isAvailable = $0 }
            }
            .toolbar {
                TeleprompterToggle(isEnabled: $model.isEnabled)
                    .disabled(!model.isAvailable)
            }
    }
}
```

**Multitasking** — all apps participate in 50/50 Split View and the stacked PiP layout. Handle both with size classes and scene geometry.

▶ [Leverage — Split view multitasking (2:59)](https://developer.apple.com/videos/play/tech-talks/111464/?time=179)

## Camera (AVFoundation / AVKit)

Use the Virtual Front Camera when it's enough, for zero extra work. Switch to individual cameras plus `AVCaptureDeviceDirectionCoordinator` when you need full resolution, full frame rate or depth.

▶ [Camera — Meet the new front cameras (0:31)](https://developer.apple.com/videos/play/tech-talks/111465/?time=31) · [Access each camera individually (1:53)](https://developer.apple.com/videos/play/tech-talks/111465/?time=113)

| Device | Max video | Depth | Switching |
| --- | --- | --- | --- |
| Virtual Front Camera (via `.front`) | 1080p 60 fps | No | Automatic |
| `.builtInOuterUltraWideCamera` | 4K 120 fps | Yes | Your app |
| `.builtInInnerUltraWideCamera` (under-display) | 1080p 60 fps | Yes | Your app |

Both front cameras use square ultra-wide sensors.

**Discovery** — returns the Virtual Front Camera on Duo: inner when open, outer when closed.

▶ [Camera — Discover the virtual front camera (0:58)](https://developer.apple.com/videos/play/tech-talks/111465/?time=58)

```swift
let discovery = AVCaptureDevice.DiscoverySession(
    deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera],
    mediaType: .video,
    position: .front)
let front = discovery.devices.first
```

**Direction coordinator** — `AVCaptureDevice.position` is `.front` for both front cameras, so it no longer tells you which way a camera faces. The coordinator reports forward or backward relative to a view. When an open device is flipped, the rear camera becomes forward-facing.

▶ [Camera — Track camera direction (2:46)](https://developer.apple.com/videos/play/tech-talks/111465/?time=166) · [Create a direction coordinator (4:03)](https://developer.apple.com/videos/play/tech-talks/111465/?time=243) · [Both displays (4:50)](https://developer.apple.com/videos/play/tech-talks/111465/?time=290) · [Device descriptors (5:38)](https://developer.apple.com/videos/play/tech-talks/111465/?time=338) · [Handle a direction change (6:17)](https://developer.apple.com/videos/play/tech-talks/111465/?time=377)

- The coordinator is `@MainActor` and tied to one view; use one per view when using both displays.
- The handler receives Sendable `AVCaptureDeviceDescriptor`s. Send them to your camera actor instead of calling AVFoundation in the handler.

```swift
directionCoordinator = AVCaptureDeviceDirectionCoordinator(
    view: previewView,
    deviceTypes: [
        .builtInOuterUltraWideCamera,
        .builtInInnerUltraWideCamera,
        .builtInDualWideCamera
    ],
    changeHandler: { [weak self] map in
        self?.updateCameraSession(map)   // pick forward-facing descriptor
    })

@MainActor
func updateCameraSession(_ map: /* direction map */ some Any) {
    // 1. Pick the forward-facing descriptor and send it to the camera actor
    // 2. Camera actor: build AVCaptureDevice from descriptor, reconfigure AVCaptureSession
    // 3. Mirror preview when the rear camera is forward-facing (selfie via flip)
    // 4. Update UI
}
```

Placeholder types in the handler are illustrative; the talk doesn't show the map's type. See "Choosing a Camera by the Direction it Faces" in the docs.

**Preview and rotation** — the rear camera on the inner display leaves spare room: offset the preview and group the controls, or fill. The ultra-wide front camera can go full landscape on the inner display via `dynamicAspectRatio`.

▶ [Camera — Polish your camera preview (7:03)](https://developer.apple.com/videos/play/tech-talks/111465/?time=423) · [Handle rotation (8:03)](https://developer.apple.com/videos/play/tech-talks/111465/?time=483) · [sensor compensation code (8:34)](https://developer.apple.com/videos/play/tech-talks/111465/?time=514)

```swift
previewLayer.videoGravity = .resizeAspectFill        // fill vs. offset with grouped controls
// device.dynamicAspectRatio — choose landscape on the inner display (square sensor)

rotationCoordinator = AVCaptureDevice.RotationCoordinator(device: device, previewLayer: previewLayer)
// Updates when the app moves between displays. After adopting it:
photoOutput.isCameraSensorOrientationCompensationEnabled = false
```

## Workshop hands-on

The workshop ends with one exercise: build a Task Tracker that works in every pose.

1. Show the list of tasks in one pane and the task details in the other.
2. Tap a task to view and edit its title, notes and done status.
3. Add new tasks with a button in the toolbar.
4. Swipe a task to mark it done or delete it.
5. Confirm before deleting.
6. Run it on the iPhone Duo simulator: open, close and partially fold.

The deck also shows custom environment values that wrap the pose checks: `isDuoOpenPortrait`, `isDuoOpenLandscape`, `isDuoOpenSplit` and `isDuoOpenFullWidth`. Their implementation is not in the deck text.

## Readiness checklist

- [ ] Build with Xcode 27.1 / iOS 27.1 SDK; test in the iPhone Duo simulator (open, close, rotate, fold, Split View left and right, PiP).
- [ ] Remove `UIScreen.main` and idiom or orientation checks for layout; use size classes, traits or scenes.
- [ ] Handle asymmetric safe areas and margins; keep foreground inside the safe area.
- [ ] Use bars from system containers; every item has a title and icon; top-to-bottom order is right.
- [ ] Set `axisBehavior` on custom items; replace count text with badges.
- [ ] Set `visibilityPriority`, compression behavior and the system overflow menu.
- [ ] Give the inner display a split, two columns or a sidebar.
- [ ] Audit centered layouts; use displacement, `ArrangementView` or reserved regions.
- [ ] Confirm features match in every pose.
- [ ] Handle multi-scene: new windows only on the inner display.
- [ ] Choose the Virtual Front Camera, or individual cameras with the direction coordinator; adopt the rotation coordinator.
- [ ] Run the App Resizability skill.

## Quick reference

| Area | SwiftUI | UIKit / AVFoundation | Use for |
| --- | --- | --- | --- |
| Size classes | `\.horizontalSizeClass`, `\.verticalSizeClass` | `traitCollection.*SizeClass` | Outer vs. inner layout |
| Screen | environment / `displayScale` | `windowScene?.screen`, `traitCollection.displayScale` | Replace `UIScreen.main` |
| Corners | `ConcentricRectangle` | `UICornerConfiguration` | Match screen corners |
| Sidebar | `.defaultTabBarPlacement(.sidebar)` | `sidebar.preferredPlacement = .sidebar` | Inner-display tabs |
| Bar order | `.cancellationAction`, `.topBarPinnedTrailing` | `leadingItemGroups`, `pinnedTrailingGroup` | Top of vertical bar |
| Item axis | `.axisBehavior(_:)` | `UIBarButtonItem.axisBehavior` | Vertical vs. horizontal |
| Bar edge | `\.toolbarVerticalEdge` | `traitCollection.verticalBarEdge` | Adapt custom items |
| Badge | `.badge(_:)` | `UIBarButtonItem.badge` | Symbol-only counts |
| Compression | `.toolbarVerticalCompressionBehavior(_:)` | `verticalBarCompressionBehavior` | Toolbar vs. tab bar |
| Overflow | `ToolbarOverflowMenu` | `additionalOverflowItems` | Single system menu |
| Priority | `.visibilityPriority(_:)` | `UIBarButtonItem.visibilityPriority` | What overflows last |
| Opt out | `.toolbarVerticalBehavior(.disabled)` | `preferredVerticalBarBehavior` | Keep horizontal bars |
| Regions | `GeometryProxy.reservedRegions(kind:options:)`, `ReservedRegion` | `UIView.reservedRegions(kind:)`, `UIViewReservedRegion` | Avoid fold / camera |
| Arrangement | `ArrangementView`, `.arrangementViewStyle`, `\.overlayArrangementZIndex` | `UIArrangementViewController`, `UISplitArrangement` | Two-view layouts |
| Hinge | `.onHingeChange` | `UIHingeInteraction` | Angle-driven effects |
| Scenes | — | `UIWindowSceneActivationAction` | New windows (inner only) |
| Accessory | `.sceneAccessory`, `CameraCaptureAccessory`, `.onAvailabilityChange` | — | Outer-display UI while capturing |
| Cameras | — | `.builtInOuterUltraWideCamera`, `.builtInInnerUltraWideCamera` | Full-capability front cameras |
| Direction | — | `AVCaptureDeviceDirectionCoordinator`, `AVCaptureDeviceDescriptor` | Which camera faces the user |
| Preview | — | `videoGravity`, `dynamicAspectRatio`, `RotationCoordinator` | Polished preview |

Names above follow the API reference. Some were checked against the local iOS 27.1 SDK headers: `reservedRegions`, `toolbarVerticalCompressionBehavior` and `leftItemsSupplementBackButton` are there, while the differing spellings in the talk notes (`toolbarCompressionBehavior`, `stateForViewPlacement`) are not.

## Sources

- [iPhone Duo API & SDK Reference](https://claude.ai/artifact/AsmYmr9XbQpY6HsRr7qSyT) (source doc)
- iPhone Duo tech talk notes: `docs/iphone-duo-tech-talks-notes.md` in the Duo Test repo
- [Prepare your app for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111461/)
- [Raise the bar with iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111462/)
- [Strike a pose with adaptive layouts on iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111463/)
- [Leverage multiple displays and scenes on iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111464/)
- [Build a great camera experience for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111465/)
- [Design for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111466/)
- [Preparing your app for iPhone Duo (docs)](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)
- Workshop deck: Develop App for iPhone Duo using SwiftUI (Keynote, William Santoso, Nov 14, 2026)
- [Designing for iPhone Duo (Human Interface Guidelines)](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo) (linked from the deck)
- [iPhone Duo](https://developer.apple.com/iphone-duo/) and [Prepare for iPhone Duo](https://developer.apple.com/iphone-duo/prepare/) (linked from the deck)

Group Labs (meet-with-apple 285–287) have no transcript, so they are not covered.
