# iPhone Duo Showcase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ubah project `Duo Test` menjadi app mockup yang memamerkan setiap API/SDK baru iPhone Duo (iOS 27.1) dalam bentuk demo hidup, plus tab use case berupa mockup app nyata, plus checklist kesiapan.

**Architecture:** Satu app target SwiftUI (`Duo Test/`, folder tersinkron otomatis — file baru otomatis ikut target). Logika murni kecil (pose, geometri fold, grid, katalog) ada di `Duo Test/Core/`. Beberapa layar UIKit dibungkus `UIViewControllerRepresentable` untuk menunjukkan pasangan API UIKit. Navigasi: `TabView` 3 tab (APIs, Use Cases, Readiness) yang sendirinya mendemokan sidebar tab dan bar vertikal.

**Tech Stack:** Xcode 27.1 (iOS 27.1 SDK), Swift 6.4 toolchain, SwiftUI + UIKit + AVFoundation/AVKit, simulator `iPhone Duo` (UDID `ACDB7A58-457A-42FD-8473-CEA6705BC0C8`). Project memakai format JSON `Duo Test.xcodeproj/project.xcproj` (bukan `.pbxproj`).

**Spec:** [`docs/iphone-duo-tech-talks-notes.md`](../../iphone-duo-tech-talks-notes.md) + materi Apple (semua simbol diverifikasi di `iPhoneOS27.1.sdk`):
- https://developer.apple.com/iphone-duo/ dan https://developer.apple.com/iphone-duo/prepare/
- https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
- https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
- Tech talks 111466 (Design), 111461 (Prepare), 111462 (Raise the bar), 111463 (Strike a pose), 111464 (Multiple displays & scenes), 111465 (Camera) — `https://developer.apple.com/videos/play/tech-talks/<id>/`

**Nama API: SDK menang atas notes.** Notes menulis beberapa nama seperti diucapkan di video; nama yang benar di `iPhoneOS27.1.sdk`:
- `toolbarCompressionBehavior` → `toolbarVerticalCompressionBehavior(_:)` (`.automatic/.prefersToolbarItems/.prefersTabBar`); UIKit `navigationItem.verticalBarCompressionBehavior`
- `GeometryProxy.reservedRegion(...)` / `UIViewReservedRegion` → `reservedRegions(kind:options:)` / `UIView.ReservedRegion`
- `stateForViewPlacement` → Swift `state(for:)`; `leftItemSupplementsBackButton` → `leftItemsSupplementBackButton`

## Global Constraints

- **Tanpa unit test / UI test target.** Verifikasi tiap task = build sukses + cek manual di simulator iPhone Duo (screenshot).
- Deployment target `IPHONEOS_DEPLOYMENT_TARGET = 27.1`; tidak ada `#available` di kode app.
- iPhone saja: `SUPPORTED_PLATFORMS = "iphoneos iphonesimulator"`, `TARGETED_DEVICE_FAMILY = "1"`, `SUPPORTS_MACCATALYST = "NO"` (beberapa API — `CameraCaptureAccessory`, `.horizontalOnly`, `.prefersTabBar` — unavailable di visionOS/macOS).
- Edit project hanya lewat `Duo Test.xcodeproj/project.xcproj` (JSON5: trailing comma diizinkan, pertahankan gaya file). Jangan buat ulang `project.pbxproj`.
- Pakai container sistem (NavigationStack/NavigationSplitView/TabView/UINavigationController) supaya bar bisa vertikal; jangan bikin `UIToolbar`/`UINavigationBar` custom kecuali satu demo "anti-pattern" yang diberi label jelas.
- Setiap toolbar item non-teks punya title **dan** SF Symbol (`Label`, atau `UIBarButtonItem(title:image:...)`).
- Jangan pakai `UIScreen.main`, `userInterfaceIdiom`, atau `interfaceOrientation` untuk layout di mana pun. String contoh "Avoid" hanya boleh muncul di `Duo Test/Core/Catalog.swift`.
- Semua demo tetap jalan di simulator tanpa hinge/kamera: tampilkan status "tidak tersedia", jangan crash.
- Teks UI bahasa Inggris (konsisten dengan istilah Apple).
- Build command baku:
  `xcodebuild -project "Duo Test.xcodeproj" -scheme "Duo Test" -destination 'platform=iOS Simulator,id=ACDB7A58-457A-42FD-8473-CEA6705BC0C8' build 2>&1 | tail -3` → harus diakhiri `** BUILD SUCCEEDED **`.
- Jalankan & lihat: `mcp__Claude_Code_iOS_Simulator__control` (`attach` dulu, lalu `launch` dengan `.app` dari DerivedData, lalu `screenshot`). Pose (closed/open/fold/rotate/Split View) diubah lewat tombol Device Hub di bawah simulator.

## Design System (native Apple look)

Sumber: skill `apple-design` (Designing Fluid Interfaces, Principles of Great Design WWDC26) dan `swift-programming` (`swiftui/liquid-glass`, `swiftui/pro/references/{api,views,data,navigation}.md`, `swiftui/whats-new-27`). Berlaku untuk semua task UI.

**Komponen & material**
- Bar, tab, sidebar, sheet, menu, alert = komponen sistem; Liquid Glass datang otomatis. Jangan memberi `.glassEffect()` pada bar atau konten yang scroll.
- `.glassEffect(...)` hanya untuk **kontrol custom yang mengambang di atas konten**: kontrol player (Task 6/9), chip `HingeGauge`, toolbar kamera. Grup kontrol mengambang → bungkus `GlassEffectContainer(spacing:)`; morph muncul/hilang via `glassEffectID(_:in:)` + animasi. Tombol mengambang → `.buttonStyle(.glass)` / `.buttonStyle(.glassProminent)` (satu prominent per layar). Interaktif → `.glassEffect(.regular.interactive())`. Jangan menumpuk glass di atas glass.
- Kartu konten (bukan mengambang): `.background(.background.secondary, in: .rect(cornerRadius: Metrics.cardRadius))`. Elemen yang menempel tepi layar → `ConcentricRectangle`.
- Hero/latar penuh → `.backgroundExtensionEffect()` agar mengalir di bawah bar vertikal/sidebar.

**Warna & tipografi**
- Hanya warna semantik (`.primary`, `.secondary`, `.tint`, `.background.secondary`) + accent di asset catalog; light/dark otomatis. Tidak ada hex hard-coded kecuali gradient dekoratif mock data.
- Hanya text style sistem (`.largeTitle` … `.caption2`) supaya Dynamic Type jalan; hierarki dari weight + size. Simbol API: `.fontDesign(.monospaced)`; angka live (sudut, inset, ukuran): `.monospacedDigit()` + `.contentTransition(.numericText())`.
- Ikon: SF Symbols saja; `.symbolEffect(.bounce, value:)` hanya saat status berubah (mis. posture).
- Label spesifik, bukan generik ("Reserved Regions", bukan "More"). Teks via interpolasi, jangan `Text + Text`.

**Gerak** (`Duo Test/Shared/Motion.swift`)
- `enum Motion { static let standard = Animation.spring(duration: 0.4, bounce: 0); static let momentum = Animation.spring(duration: 0.35, bounce: 0.2); static let reduced = Animation.easeInOut(duration: 0.2) }` — `standard` = damping 1.0/response 0.4 (default semua perubahan layout, termasuk displacement saat fold); `momentum` hanya setelah gesture yang membawa momentum (flick/drag release).
- Nilai yang dikendalikan langsung oleh hinge (sudut, pitch bend, gauge) mengikuti 1:1 **tanpa** animasi — direct manipulation.
- Selalu `.animation(_:value:)` dengan value; rantai animasi pakai `withAnimation { } completion: { }`.
- `@Environment(\.accessibilityReduceMotion)` → ganti `standard`/`momentum` dengan `reduced` (cross-fade, tanpa overshoot). Helper: `static func resolve(_ animation: Animation, reduceMotion: Bool) -> Animation`.
- Transisi kartu use case → detail: `.matchedTransitionSource(id:in:)` + `.navigationTransition(.zoom(sourceID:in:))` (masuk & keluar lewat jalur yang sama).

**Haptic** — `sensoryFeedback`, bukan `UIImpactFeedbackGenerator`; hanya di momen bermakna: `.selection` saat posture berubah, `.impact(weight: .light)` saat pitch bend menyentuh 1, `.success` saat checklist Readiness lengkap.

**Aturan kode SwiftUI** (dari `swift-programming`)
- Satu tipe per file; subview diekstrak jadi `struct` sendiri (bukan computed `some View`); aksi tombol jadi method.
- `@State` selalu `private` dan diinisialisasi di satu tempat (di Xcode 27 `@State` adalah macro). Shared model = `@Observable` (MainActor default sudah aktif), dilewatkan via `@Environment`/`@Bindable`.
- Navigasi: `navigationDestination(for:)` per tipe data per stack; jangan campur dengan `NavigationLink(destination:)`. `TabView(selection:)` memakai enum `AppTab`.
- State per-window (tab aktif, item terpilih) di `@State` scene-root atau `@SceneStorage` — inner display bisa punya dua window independen.
- `.topBarPinnedTrailing` maksimal satu item per bar; item terkait dikelompokkan `ToolbarItemGroup`; aksi sering dipakai `.visibilityPriority(.high)`.
- `ForEach` pakai id elemen yang stabil, tidak pernah index. `foregroundStyle` bukan `foregroundColor`; `clipShape(.rect(cornerRadius:))` bukan `cornerRadius()`; `onChange` versi 2 parameter atau 0 parameter.
- `.hidden()` pada toolbar item **tidak** tersedia di Xcode 27.1 — pakai kondisi biasa.

## Review Focus

Tanpa unit test, lima kasus ini wajib dicek manual oleh task pemiliknya:

1. **Tidak ada hinge** (`context.hinge == nil` / `update.hinge == nil`) → posture `.unavailable`, pitch bend 0, UI menulis "No hinge on this device" (Task 7).
2. **Division inaktif** (device terbuka penuh: region ada tapi `isActive == false`, lebar 0) → satu pane, bukan dua pane dengan celah 0 (Task 6).
3. **Container lebih sempit dari item minimum** (outer landscape, Split View 50/50) → grid minimal 1 kolom; aturan "genap saat ada division" tidak menurunkan 1 jadi 0 (Task 9 `photoGrid`).
4. **Sudut hinge di luar rentang / NaN** → pitch bend tetap di [0, 1] (Task 2 logika, dicek Task 7 dengan sudut ekstrem di Device Hub).
5. **Kamera tidak tersedia / izin ditolak** (simulator selalu tanpa kamera) → state jelas, bukan preview hitam/crash; tombol teleprompter disabled (Task 8).

---

## File Structure

```
Duo Test.xcodeproj/project.xcproj     (modify: build settings)
Duo Test/
  MyApp.swift                          (modify: RootView + WindowGroup(id: "detail"))
  ContentView.swift                    (delete)
  Core/Posture.swift                   — Posture, HingeReading, mapping dari DeviceHinge/UIHinge
  Core/FoldMath.swift                  — PitchBend, FoldSplit/FoldPanes, GridPolicy, OcclusionAvoidance
  Core/CameraDemoState.swift           — state layar kamera
  Core/Catalog.swift                   — TechTalk, APIArea, APIEntry, UseCase, ReadinessItem + data
  Shell/RootView.swift, AppTab.swift, APICatalogView.swift, APIDetailView.swift, APIDemoRouter.swift,
        UseCaseCatalogView.swift, UseCaseCard.swift, UseCaseRouter.swift, ReadinessView.swift, ReadinessRow.swift
  Shared/Motion.swift, Metrics.swift, Card.swift, SymbolChip.swift, DemoLauncher.swift,
         LiveEnvironmentPanel.swift, APIHeader.swift, HingeGauge.swift
  Demos/Layout/*, Demos/Bars/*, Demos/Regions/*, Demos/Hinge/*, Demos/Scenes/*, Demos/Camera/*
  UseCases/*
```

---

### Task 1: Konfigurasi project

**Files:**
- Modify: `Duo Test.xcodeproj/project.xcproj`

**Interfaces:**
- Produces: target iPhone-only iOS 27.1 dengan izin kamera dan multiple scenes.

- [ ] **Step 1:** Di `targets[0]["build-settings"]`:
  - `"SUPPORTED_PLATFORMS": "iphoneos iphonesimulator"`
  - `"TARGETED_DEVICE_FAMILY": "1"`
  - tambah `"SUPPORTS_MACCATALYST": "NO"`
  - hapus `"INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad"` dan `"LD_RUNPATH_SEARCH_PATHS[sdk=macosx*]"`
  - tambah `"INFOPLIST_KEY_NSCameraUsageDescription": "Demonstrates the iPhone Duo front cameras and camera capture accessory."`
  - tambah `"INFOPLIST_KEY_UIApplicationSupportsMultipleScenes[sdk=iphoneos*]": "YES"` dan `"...[sdk=iphonesimulator*]": "YES"`
- [ ] **Step 2:** Di `build-settings` level project: `"IPHONEOS_DEPLOYMENT_TARGET": "27.1"`; hapus `MACOSX_/TVOS_/WATCHOS_/XROS_/DRIVERKIT_DEPLOYMENT_TARGET`.
- [ ] **Step 3: Verifikasi settings:**
  `xcodebuild -project "Duo Test.xcodeproj" -scheme "Duo Test" -destination 'platform=iOS Simulator,id=ACDB7A58-457A-42FD-8473-CEA6705BC0C8' -showBuildSettings | grep -E " (IPHONEOS_DEPLOYMENT_TARGET|SUPPORTED_PLATFORMS|TARGETED_DEVICE_FAMILY) ="`
  → `27.1`, `iphoneos iphonesimulator`, `1`.
- [ ] **Step 4:** Build command baku → `** BUILD SUCCEEDED **`. Lalu cek Info.plist hasil build:
  `plutil -extract UIApplicationSceneManifest.UIApplicationSupportsMultipleScenes raw "$(find ~/Library/Developer/Xcode/DerivedData -path '*Debug-iphonesimulator/Duo Test.app/Info.plist' -newer 'Duo Test.xcodeproj/project.xcproj' | head -1)"` → `true`. Bila bukan `true`, buat `Duo Test/Info.plist` berisi `UIApplicationSceneManifest` → `UIApplicationSupportsMultipleScenes = YES` dan set `"INFOPLIST_FILE": "Duo Test/Info.plist"` (generate tetap `YES`, keduanya digabung).
- [ ] **Step 5: Commit** (ikutkan konversi format yang sudah kamu lakukan):
```bash
git add -A "Duo Test.xcodeproj/project.pbxproj" "Duo Test.xcodeproj/project.xcproj"
git commit -m "chore: JSON project format, iPhone-only iOS 27.1 target"
```

---

### Task 2: Core — pose, geometri fold, state kamera

**Files:**
- Create: `Duo Test/Core/Posture.swift`, `Duo Test/Core/FoldMath.swift`, `Duo Test/Core/CameraDemoState.swift`

**Interfaces:**
- Produces:
  - `enum Posture: String, CaseIterable, Sendable { case unavailable, closed, partiallyOpen, fullyOpen; var title: String }`
  - `extension Posture { init(_ hinge: DeviceHinge?); init(_ hinge: UIHinge?) }` — `nil` → `.unavailable`. `DeviceHinge.Status` adalah struct (bandingkan `==` dengan `.closed/.partiallyOpen/.fullyOpen`); `UIHinge.Status` enum (+ `.unknown` → `.unavailable`).
  - `struct HingeReading: Equatable, Sendable { var posture: Posture; var angleDegrees: Double?; static let unavailable }`
  - `enum PitchBend { static func normalized(angleDegrees: Double, posture: Posture) -> Double }` — 0 bila posture ≠ `.partiallyOpen` atau angle tidak finite; selain itu `min(max((180 - angle) / 90, 0), 1)`. (180° → 0, 135° → 0.5, ≤ 90° → 1.)
  - `enum FoldPanes: Equatable { case single(CGRect); case sideBySide(leading: CGRect, trailing: CGRect); case stacked(top: CGRect, bottom: CGRect) }`
  - `enum FoldSplit { static func panes(container: CGSize, division: CGRect?) -> FoldPanes }` — `nil`, `width <= 0 || height <= 0`, atau tidak `intersects` `CGRect(origin: .zero, size: container)` → `.single`. Division lebih tinggi daripada lebar → `.sideBySide` (leading `0..<minX`, trailing `maxX..<width`), sebaliknya `.stacked`.
  - `enum GridPolicy { static func columns(width: CGFloat, minItemWidth: CGFloat, hasDivision: Bool) -> Int }` — `max(1, Int(width / minItemWidth))`; bila `hasDivision` dan ganjil dan > 1 → kurangi 1.
  - `enum OcclusionAvoidance { static func topInset(barFrame: CGRect, occlusions: [CGRect]) -> CGFloat }` — `maxY` terbesar dari occlusion yang `intersects(barFrame)`, else 0.
  - `enum CameraAuthorization { case notDetermined, authorized, denied }`; `enum CameraDemoState: Equatable { case needsPermission, permissionDenied, noCamera, ready; static func resolve(authorization: CameraAuthorization, hasDevices: Bool) -> Self }` — denied → `.permissionDenied`; notDetermined → `.needsPermission`; authorized & !hasDevices → `.noCamera`; else `.ready`.

- [ ] **Step 1:** Implementasi ketiga file sesuai Interfaces.
- [ ] **Step 2:** Build command baku → sukses.
- [ ] **Step 3: Commit** — `git add "Duo Test/Core" && git commit -m "feat: core posture, fold geometry and camera state helpers"`

---

### Task 3: Core — katalog API, use case, readiness

**Files:**
- Create: `Duo Test/Core/Catalog.swift`

**Interfaces:**
- Consumes: `Posture`.
- Produces:
  - `enum TechTalk: String, CaseIterable { case design = "111466", prepare = "111461", raiseTheBar = "111462", strikeAPose = "111463", multipleDisplays = "111464", camera = "111465"; var title: String; var url: URL }` — url `https://developer.apple.com/videos/play/tech-talks/<rawValue>/`, title persis judul video.
  - `enum APIArea: String, CaseIterable { case layout, bars, regions, arrangements, hinge, scenes, camera; var title: String; var systemImage: String }` — titles "Adaptive Layout", "Vertical Bars", "Reserved Regions", "Arrangements", "Hinge", "Scenes & Displays", "Camera".
  - `struct APIEntry: Identifiable, Hashable { let id: String; let area: APIArea; let title: String; let summary: String; let swiftUISymbols: [String]; let uiKitSymbols: [String]; let talk: TechTalk; let deviceOnly: Bool }`
  - `struct UseCase: Identifiable, Hashable { let id: String; let title: String; let summary: String; let poses: [Posture]; let apiIDs: [String] }`
  - `struct ReadinessItem: Identifiable, Hashable { let id: String; let step: Int; let title: String; let avoid: String; let prefer: String }`
  - `enum Catalog { static let apis: [APIEntry]; static let useCases: [UseCase]; static let readiness: [ReadinessItem]; static func api(id: String) -> APIEntry? }`

**Data API (19 entri):**

| id | area | SwiftUI | UIKit / lain | talk | deviceOnly |
|---|---|---|---|---|---|
| `sizeClasses` | layout | `horizontalSizeClass`, `verticalSizeClass`, `onGeometryChange` | `traitCollection.horizontalSizeClass`, `windowScene.screen` | prepare | no |
| `asymmetricSafeArea` | layout | `safeAreaInsets`, `ignoresSafeArea` | `safeAreaInsets`, `bounds.inset(by:)` | prepare | no |
| `concentricity` | layout | `ConcentricRectangle` | `UICornerConfiguration` | prepare | no |
| `tabSidebar` | layout | `defaultTabBarPlacement(.sidebar)` | `sidebar.preferredPlacement` | prepare | no |
| `sceneGeometry` | layout | `GeometryReader` | `effectiveGeometry`, `isInteractivelyResizing` | prepare | no |
| `verticalBars` | bars | `ToolbarItem(placement:)`, `.cancellationAction`, `.topBarPinnedTrailing` | `leadingItemGroups`, `pinnedTrailingGroup` | raiseTheBar | no |
| `axisBehavior` | bars | `axisBehavior(_:)`, `badge` | `UIBarButtonItem.axisBehavior`, `badge` | raiseTheBar | no |
| `overflow` | bars | `ToolbarOverflowMenu`, `visibilityPriority`, `toolbarVerticalCompressionBehavior` | `additionalOverflowItems`, `visibilityPriority`, `verticalBarCompressionBehavior` | raiseTheBar | no |
| `verticalBarEdge` | bars | `toolbarVerticalEdge`, `backgroundExtensionEffect` | `verticalBarEdge`, `UIBackgroundExtensionView` | raiseTheBar | no |
| `sheetBars` | bars | `toolbarVerticalBehavior(.disabled)`, `presentationPlacement` | `preferredVerticalBarBehavior`, `preferredPlacement` | raiseTheBar | no |
| `reservedRegions` | regions | `reservedRegions(kind:options:)`, `ReservedRegion` | `UIView.reservedRegions(kind:options:)` | strikeAPose | no |
| `splitArrangement` | arrangements | `ArrangementView`, `.split.axes(_:)` | `UIArrangementViewController`, `updateArrangement` | strikeAPose | no |
| `overlayArrangement` | arrangements | `.overlay`, `overlayArrangementZIndex` | `state(for:).zIndex` | strikeAPose | no |
| `hingeSwiftUI` | hinge | `onHingeChange`, `DeviceHinge` | — | multipleDisplays | no |
| `hingeUIKit` | hinge | — | `UIHingeInteraction`, `UIHinge` | multipleDisplays | no |
| `multiWindow` | scenes | `openWindow`, `WindowGroup(id:)` | `UIWindowSceneActivationAction` | multipleDisplays | no |
| `cameraAccessory` | scenes | `sceneAccessory`, `CameraCaptureAccessory`, `onAvailabilityChange` | — | multipleDisplays | yes |
| `virtualFrontCamera` | camera | — | `AVCaptureDevice.DiscoverySession`, `.builtInOuterUltraWideCamera`, `.builtInInnerUltraWideCamera` | camera | yes |
| `directionCoordinator` | camera | — | `AVCaptureDeviceDirectionCoordinator`, `dynamicAspectRatio`, `isCameraSensorOrientationCompensationEnabled` | camera | yes |

**Use case (7):**
- `mail` "Mail continuity" — closed, fullyOpen — `sizeClasses`, `verticalBars`, `tabSidebar`
- `podcast` "Podcast + transcript" — fullyOpen, partiallyOpen — `splitArrangement`, `overflow`
- `tabletopVideo` "Tabletop video" — partiallyOpen — `overlayArrangement`, `reservedRegions`
- `airGuitar` "Air guitar whammy" — partiallyOpen — `hingeSwiftUI`
- `teleprompter` "Teleprompter rehearsal" — fullyOpen — `cameraAccessory`, `directionCoordinator`
- `photoGrid` "Fold-aware photo grid" — fullyOpen, partiallyOpen — `reservedRegions`, `asymmetricSafeArea`
- `calculator` "Full-width calculator" — closed — `sheetBars`, `verticalBarEdge`

**Readiness (dari "Three steps"):**
1 `appResizabilitySkill` "Run the App Resizability skill" — prefer: ask Xcode agent "get my app ready for iPhone Duo" / `xcrun agent skills export`
2 `mainScreen`: `UIScreen.main.bounds` → `view.bounds` / `GeometryReader` / `onGeometryChange`
2 `displayScale`: `UIScreen.main.scale` → `traitCollection.displayScale` / `@Environment(\.displayScale)`
2 `windowFromScene`: `UIWindow(frame: UIScreen.main.bounds)` → `UIWindow(windowScene:)`
2 `orientation`: `interfaceOrientation` / `UIDevice.current.orientation` → compare width vs height
2 `idiom`: `userInterfaceIdiom == .pad` → size classes / available space
2 `fixedSizes`: `bounds.height == 844` → size relative to container
2 `fullBleed`: always `.aspectRatio(contentMode: .fill)` → choose fill/fit by size class or aspect
3 `testResizing`: Device Hub resizable simulator, iPhone Mirroring (macOS 27), iPhone Duo simulator — open/close/rotate/fold, Split View kiri & kanan, PiP di-pin di atas

Tambah juga `static let duoChecklist: [String]` di `Catalog` = 12 butir "Checklist kesiapan" dari `docs/iphone-duo-tech-talks-notes.md` (baris 131–142, disalin apa adanya), ditampilkan `ReadinessView` sebagai seksi kedua "iPhone Duo checklist".

- [ ] **Step 1:** Implementasi `Catalog.swift`; summary satu kalimat per entri, ditulis ulang sendiri.
- [ ] **Step 2:** Tambah `assert` di inisialisasi `Catalog.apis` (debug only) bahwa id unik dan setiap `UseCase.apiIDs` ada di `apis` — murah, menangkap typo id saat app jalan.
- [ ] **Step 3:** Build → sukses.
- [ ] **Step 4: Commit** — `git commit -m "feat: API, use case and readiness catalog"` (setelah `git add "Duo Test/Core"`).

---

### Task 4: App shell

**Files:**
- Modify: `Duo Test/MyApp.swift`
- Delete: `Duo Test/ContentView.swift`
- Create: `Duo Test/Shell/RootView.swift`, `AppTab.swift`, `APICatalogView.swift`, `APIDetailView.swift`, `APIDemoRouter.swift`, `UseCaseCatalogView.swift`, `UseCaseCard.swift`, `UseCaseRouter.swift`, `ReadinessView.swift`, `ReadinessRow.swift`
- Create: `Duo Test/Shared/Motion.swift`, `Metrics.swift`, `Card.swift`, `SymbolChip.swift`, `DemoLauncher.swift`, `LiveEnvironmentPanel.swift`, `APIHeader.swift`

**Interfaces:**
- Consumes: `Catalog`, `APIEntry`, `UseCase`, `ReadinessItem`, `Posture(_:)`, `HingeReading`.
- Produces:
  - `struct APIDemoRouter: View { let entry: APIEntry }` — `switch entry.id`, default `ContentUnavailableView("Coming soon", systemImage: "hammer")`. Task 5–8 menambah case.
  - `struct UseCaseRouter: View { let useCase: UseCase }` — sama; Task 9 menambah case.
  - `struct APIHeader: View { let entry: APIEntry }` — judul, summary, chip simbol SwiftUI/UIKit (monospace), `Link` ke `entry.talk.url`, badge "Device only".
  - `struct LiveEnvironmentPanel: View` — size class H/V, ukuran (`onGeometryChange(for: CGSize.self)`), `safeAreaInsets` 4 sisi terpisah, `toolbarVerticalEdge` (`nil` → "none"), posture + sudut dari `onHingeChange`.
  - `MyApp`: `WindowGroup { RootView() }` + `WindowGroup("Detail", id: "detail", for: String.self) { $id in ... }` (dipakai Task 7).
  - `enum AppTab: String, Hashable { case apis, useCases, readiness }`.
  - `Motion` (lihat Design System), `enum Metrics { static let cardRadius: CGFloat = 20; static let spacing: CGFloat = 16 }`.
  - `struct Card<Content: View>: View { init(@ContentBuilder content: () -> Content) }` — padding `Metrics.spacing`, background `.background.secondary` dalam `.rect(cornerRadius: Metrics.cardRadius)`.
  - `struct SymbolChip: View { let symbol: String }` — `.fontDesign(.monospaced)`, `.font(.caption)`, capsule `.background.tertiary`.
  - `struct DemoLauncher<Demo: View>: View { let title: LocalizedStringKey; let systemImage: String; @ContentBuilder let demo: () -> Demo }` — tombol `.buttonStyle(.glassProminent)` "Open demo" yang menampilkan `demo()` di `.fullScreenCover`, dibungkus `NavigationStack` dengan `ToolbarItem(placement: .cancellationAction) { Button("Close", systemImage: "xmark", action: dismiss) }`. **Wajib** untuk demo yang punya bar sendiri atau `ArrangementView` (Task 5 bars, Task 6 arrangements, Task 9 mockup), supaya bar-nya milik window (bisa vertikal) dan tidak ada `NavigationStack` bersarang di dalam detail column.

- [ ] **Step 1:** `RootView`: `TabView(selection: $tab)` (`@State private var tab: AppTab`, disimpan `@SceneStorage("tab")`) dengan `Tab("APIs", systemImage: "square.stack.3d.up", value: .apis)`, `Tab("Use Cases", systemImage: "rectangle.split.2x1", value: .useCases)`, `Tab("Readiness", systemImage: "checklist", value: .readiness)`, `.tabViewStyle(.sidebarAdaptable)`, `.defaultTabBarPlacement(.sidebar)`.
- [ ] **Step 2:** `APICatalogView`: `NavigationSplitView` — sidebar `List(selection: $selectedID)` di-section per `APIArea` (header pakai `Label(area.title, systemImage: area.systemImage)`); detail `APIDetailView(entry:)` = `ScrollView { APIHeader; Card { DisclosureGroup("Live environment") { LiveEnvironmentPanel() } }; APIDemoRouter }` dengan `.navigationTitle(entry.title)`. Toolbar detail: tepat satu `ToolbarItem(placement: .topBarPinnedTrailing) { ShareLink(item: entry.talk.url) { Label("Share talk", systemImage: "square.and.arrow.up") } }`. Seleksi di `@SceneStorage`.
- [ ] **Step 3:** `UseCaseCatalogView`: `NavigationStack` dengan `ScrollView { LazyVGrid(columns: [GridItem(.adaptive(minimum: 260))]) { ForEach(Catalog.useCases) { UseCaseCard } } }`; `UseCaseCard` = `Card` berisi gradient preview, judul `.headline`, summary `.subheadline .secondary`, chip pose. Navigasi `NavigationLink(value: useCase)` + `.navigationDestination(for: UseCase.self)` dengan `.matchedTransitionSource(id: useCase.id, in: namespace)` dan `.navigationTransition(.zoom(sourceID: useCase.id, in: namespace))`. Detail use case menampilkan apiIDs sebagai `NavigationLink(value: APIEntry)` + `.navigationDestination(for: APIEntry.self) { APIDetailView(entry: $0) }`.
- [ ] **Step 4:** `ReadinessView`: `List` per step; `ReadinessRow` menampilkan "Avoid" (`.red`, monospace) dan "Prefer" (`.green`, monospace) + `Toggle`; progres di header `Gauge`; `.sensoryFeedback(.success, trigger: allDone)` saat semua tercentang.
- [ ] **Step 5:** Hapus `ContentView.swift`; build → sukses.
- [ ] **Step 6: Cek simulator:** closed (outer) → bar vertikal di sisi kanan, tidak ada konten tertutup; open (inner) → tab tampil sebagai sidebar; dark mode + ukuran teks Accessibility XL → layout tidak terpotong; zoom transition kartu use case masuk & keluar dari kartu yang sama. Simpan screenshot.
- [ ] **Step 7: Commit** — `git add -A "Duo Test" && git commit -m "feat: app shell with API, use case and readiness tabs"`

---

### Task 5: Demo Adaptive Layout + Vertical Bars

**Files:**
- Create: `Duo Test/Demos/Layout/SizeClassDemo.swift`, `SafeAreaDemo.swift`, `ConcentricDemo.swift`, `TabSidebarDemo.swift`, `SceneGeometryDemo.swift`
- Create: `Duo Test/Demos/Bars/VerticalBarsDemo.swift`, `UIKitBarsViewController.swift`, `AxisBehaviorDemo.swift`, `OverflowDemo.swift`, `VerticalBarEdgeDemo.swift`, `SheetBarsDemo.swift`
- Modify: `Shell/APIDemoRouter.swift`

**Interfaces:**
- Produces: 10 view tanpa parameter, satu per id `sizeClasses`, `asymmetricSafeArea`, `concentricity`, `tabSidebar`, `sceneGeometry`, `verticalBars`, `axisBehavior`, `overflow`, `verticalBarEdge`, `sheetBars`.

Isi:
- `SizeClassDemo`: `VStack`↔`HStack` berdasar `horizontalSizeClass == .regular`; label "wider than tall" dari width vs height; tabel kombinasi iPhone Duo (outer portrait C/R, outer landscape C/C, inner R/R).
- `SafeAreaDemo`: background `ignoresSafeArea()`, kartu foreground di safe area, garis + nilai inset per sisi; kontras "❌ width - left * 2" vs "✅ bounds.inset(by:)".
- `ConcentricDemo`: `ConcentricRectangle().fill(.tint).padding(8).ignoresSafeArea()` di belakang konten.
- `TabSidebarDemo`: `TabView` mini 3 tab; `Toggle` ganti `.defaultTabBarPlacement` `.sidebar`/`.automatic`.
- `SceneGeometryDemo`: representable → `SceneGeometryViewController` yang di `viewDidLayoutSubviews` menampilkan `view.window?.windowScene?.effectiveGeometry.coordinateSpace.bounds`, `isInteractivelyResizing`, `traitCollection.displayScale`.
- Semua demo **Bars** (`verticalBars`, `axisBehavior`, `overflow`, `sheetBars`, dan bagian bar `verticalBarEdge`) dibuka lewat `DemoLauncher` (fullScreenCover) — konten demo-nya sendiri tidak membuat `NavigationStack` lagi karena `DemoLauncher` sudah menyediakannya; demo UIKit membawa `UINavigationController` sendiri dan ditampilkan tanpa `NavigationStack` pembungkus.
- `VerticalBarsDemo`: `Picker("Framework")` SwiftUI/UIKit. SwiftUI: toolbar `.cancellationAction` Close, `.topBarPinnedTrailing` Done, `.bottomBar` group Share/Favorite/Delete. UIKit (`UINavigationController(rootViewController: UIKitBarsViewController())`): `leftItemsSupplementBackButton = false`, `leadingItemGroups`, `pinnedTrailingGroup`, `toolbarItems`, plus satu `UIToolbar` custom berlabel "Anti-pattern: custom UIToolbar stays horizontal".
- `AxisBehaviorDemo`: `CompassView` `.axisBehavior(.verticalPreferred)` yang membaca `toolbarVerticalEdge` dan menyembunyikan teksnya saat vertikal, Select/Done custom `.axisBehavior(.horizontalOnly)`, inbox `.badge(7)` (ganti angka inline), item teks-saja "Edit" sebagai pembanding yang tetap horizontal; UIKit `item.axisBehavior`, `item.badge = .count(7)`.
- `OverflowDemo`: 8 item; Picker `.toolbarVerticalCompressionBehavior(.automatic/.prefersToolbarItems/.prefersTabBar)` dalam `TabView` 2 tab; `ToolbarOverflowMenu { Button("Scan"); Button("Connect") }`; Compose `.visibilityPriority(.high)`.
- `VerticalBarEdgeDemo`: `@Environment(\.toolbarVerticalEdge)` → "Leading"/"Trailing"/"No vertical bar"; hero gradient `.backgroundExtensionEffect()`; UIKit VC `registerForTraitChanges(UITraitCollection.systemTraitsAffectingVerticalBarEdge)` membaca `traitCollection.verticalBarEdge`.
- `SheetBarsDemo`: sheet default vs `.toolbarVerticalBehavior(.disabled)`; Picker `presentationPlacement` untuk inner display.

- [ ] **Step 1:** Implementasi 10 view + case router.
- [ ] **Step 2:** Build → sukses.
- [ ] **Step 3: Cek simulator:** `SafeAreaDemo` di outer landscape dan Split View kiri → leading ≠ trailing terlihat; `AxisBehaviorDemo` dengan Settings › Accessibility › Reduce Transparency ON → `CompassView` tetap terbaca; `OverflowDemo` outer landscape → Compose bertahan paling lama; `VerticalBarEdgeDemo` inner portrait → "No vertical bar", outer → "Trailing".
- [ ] **Step 4: Commit** — `git add "Duo Test" && git commit -m "feat: adaptive layout and vertical bar demos"`

---

### Task 6: Demo Reserved Regions + Arrangements

**Files:**
- Create: `Duo Test/Demos/Regions/ReservedRegionsDemo.swift`, `ReservedRegionsUIKitViewController.swift`, `ArrangementDemo.swift`, `ArrangementUIKitDemo.swift`
- Modify: `Shell/APIDemoRouter.swift`

**Interfaces:**
- Consumes: `FoldSplit.panes`, `OcclusionAvoidance.topInset`.
- Produces: `ReservedRegionsDemo`, `ArrangementDemo(initialStyle: ArrangementDemoStyle)` dengan `enum ArrangementDemoStyle: CaseIterable { case split, splitHorizontalOnly, overlay }`; `PlayerMock`, `UpNextMock` (dipakai ulang Task 9).

Isi:
- `ReservedRegionsDemo`: `GeometryReader { proxy in }` → `proxy.reservedRegions(kind: .division, options: includeInactive ? .includeInactive : [])` dan `.occlusion`; overlay `region.frame` (division oranye, occlusion merah, inactive garis putus-putus) + label `isActive`. Di bawahnya: panel dua pane dari `FoldSplit.panes` dengan division **aktif** pertama; bar custom `.padding(.top, OcclusionAvoidance.topInset(...))`. Toggle "Include inactive".
  - Seksi **Displacement**: kartu "Now Playing" yang di tengah saat flat; saat `.sideBySide` pindah ke pane trailing (book), saat `.stacked` kontrolnya ke pane bawah dan info ke pane atas (tabletop). Geser hanya kartu itu, bukan seluruh layar; `.animation(Motion.resolve(Motion.standard, reduceMotion:), value: panes)` (spring tanpa overshoot; cross-fade saat Reduce Motion).
  - Seksi **System fold avoidance**: tombol yang membuka `alert`, `confirmationDialog`, `Menu`, `contextMenu`, dan `sheet` — untuk menunjukkan komponen sistem otomatis menghindari fold tanpa kode tambahan.
  - Satu `List` panjang di bawahnya sebagai contoh konten scroll yang **tidak** di-displace. UIKit counterpart: `view.reservedRegions(kind:options:)` di `viewDidLayoutSubviews`.
- `ArrangementDemo` dibuka lewat `DemoLauncher` (NavigationStack di luar ArrangementView, sesuai aturan Apple): `ArrangementView { PlayerMock() } secondary: { UpNextMock() }.arrangementViewStyle(...)`; perubahan style dianimasikan `Motion.standard`; kontrol `PlayerMock` mengambang memakai `GlassEffectContainer` + `.buttonStyle(.glass)` (play = `.glassProminent`); Picker Split / Split horizontal-only (`.split.axes(.horizontal)`) / Overlay; di Overlay, `UpNextMock` membaca `@Environment(\.overlayArrangementZIndex)` → collapsed bila `> 0`. UIKit: `UIArrangementViewController`, `setViewController(_:for: .primary/.secondary)`, `updateArrangement(...)`, `state(for: .primary)?.zIndex`.

- [ ] **Step 1:** Implementasi + case router.
- [ ] **Step 2:** Build → sukses.
- [ ] **Step 3: Cek simulator (Review Focus #2):** fully open → panel satu pane; include inactive → garis putus-putus lebar 0; book fold → sideBySide; laptop → stacked. Arrangement: rotasi inner portrait dengan split horizontal-only → hanya Player tampil. Screenshot tiap pose.
- [ ] **Step 4: Commit** — `git commit -m "feat: reserved region and arrangement demos"`

---

### Task 7: Demo Hinge + Multi-window

**Files:**
- Create: `Duo Test/Shared/HingeGauge.swift`, `Duo Test/Demos/Hinge/HingeSwiftUIDemo.swift`, `HingeUIKitViewController.swift`, `Duo Test/Demos/Scenes/MultiWindowDemo.swift`
- Modify: `Shell/APIDemoRouter.swift`, `Duo Test/MyApp.swift` (isi window `detail`)

**Interfaces:**
- Consumes: `Posture(_:)`, `HingeReading`, `PitchBend.normalized`.
- Produces: `struct HingeGauge: View { let reading: HingeReading }` (busur 0–180°, status, bar pitch bend) — dipakai ulang Task 9 `airGuitar`. Gauge mengambang dengan `.glassEffect(in: .rect(cornerRadius: Metrics.cardRadius))`; sudut `.monospacedDigit()` + `.contentTransition(.numericText())` tanpa animasi tambahan (ikut hinge 1:1); ikon posture `.symbolEffect(.bounce, value: reading.posture)`; `.sensoryFeedback(.selection, trigger: reading.posture)` dan `.sensoryFeedback(.impact(weight: .light), trigger: bendMaxed)` saat pitch bend mencapai 1.

Isi:
- `HingeSwiftUIDemo`: `.onHingeChange { _, context in reading = HingeReading(posture: Posture(context.hinge), angleDegrees: context.hinge?.angle.degrees) }`; `nil` → "No hinge on this device". Catatan: "For layout, use arrangements and reserved regions — hinge is for interactions and effects."
- UIKit: `UIHingeInteraction { [weak self] _, update in ... }` + `view.addInteraction`; `update.hinge == nil` → unavailable; radian → derajat; Toggle `interaction.isEnabled`.
- `MultiWindowDemo`: tombol `openWindow(id: "detail", value: entryID)` di-disable saat `horizontalSizeClass == .compact` dengan caption "New windows can only be created on the inner display"; UIKit `UIButton` dengan `UIWindowSceneActivationAction` (auto-hide oleh sistem).

- [ ] **Step 1:** Implementasi + case router.
- [ ] **Step 2:** Build → sukses.
- [ ] **Step 3: Cek simulator (Review Focus #1, #4):** geser hinge di Device Hub → sudut & status berubah; closed → Closed, pitch bend 0; fully open → pitch bend 0; lipat sangat dalam → pitch bend tepat 1, tidak lebih. Inner → buka window detail berhasil; outer → tombol disabled.
- [ ] **Step 4: Commit** — `git commit -m "feat: hinge and multi-window demos"`

---

### Task 8: Demo Camera

**Files:**
- Create: `Duo Test/Demos/Camera/CameraModel.swift`, `CameraPreviewView.swift`, `CameraDirectionDemo.swift`, `TeleprompterAccessoryDemo.swift`
- Modify: `Shell/APIDemoRouter.swift`

**Interfaces:**
- Consumes: `CameraDemoState.resolve`, `CameraAuthorization`.
- Produces:
  - `actor CameraSessionActor` — memegang `AVCaptureSession`; `func configure(with descriptor: AVCaptureDeviceDescriptor) async throws`.
  - `@Observable final class CameraModel { var state: CameraDemoState; var discoveredDevices: [String]; var forwardFacing: String?; var teleprompterEnabled: Bool; var accessoryAvailable: Bool; func start(in view: UIView) async }`
  - `TeleprompterAccessoryDemo` (dipakai ulang Task 9).

Isi:
- Discovery: `AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInOuterUltraWideCamera, .builtInInnerUltraWideCamera], mediaType: .video, position: .unspecified)` → daftar nama + posisi; tandai Virtual Front Camera.
- `AVCaptureDeviceDirectionCoordinator(view:deviceTypes:changeHandler:)` dengan `[.builtInOuterUltraWideCamera, .builtInInnerUltraWideCamera, .builtInDualWideCamera]`; handler hanya update UI + kirim descriptor ke actor (jangan panggil AVFoundation di handler); mirror preview bila kamera belakang forward-facing. Baca `AVKit.framework/Headers/AVCaptureDeviceDirectionCoordinator.h` dulu untuk nama properti peta.
- Rotasi: `AVCaptureDevice.RotationCoordinator(device:previewLayer:)` → terapkan `videoRotationAngleForHorizonLevelPreview` ke preview connection (berubah juga saat app pindah display); **setelah** itu `isCameraSensorOrientationCompensationEnabled = false` di photo output dengan komentar alasan (performa).
- Preview: Picker `videoGravity` (`.resizeAspect`/`.resizeAspectFill`) + opsi "offset preview, kontrol di ruang sisa" untuk kamera belakang di inner; tampilkan `dynamicAspectRatio` (landscape penuh untuk ultrawide depan di inner).
- Kartu info: Virtual Front Camera = maks 1080p/60fps tanpa depth; kamera individual = kemampuan penuh (outer 4K/120fps, inner 1080p/60fps) + depth, tapi app wajib switch sendiri.
- `TeleprompterAccessoryDemo`: `CameraPreviewView(model:).sceneAccessory { CameraCaptureAccessory(isEnabled: $model.teleprompterEnabled) { TeleprompterView() }.onAvailabilityChange { model.accessoryAvailable = $0 } }` + toolbar toggle `.disabled(!model.accessoryAvailable)`. View accessory punya `AVCaptureDeviceDirectionCoordinator` **sendiri** (satu coordinator per view/display) dan menampilkan kamera mana yang forward-facing dari sudut pandang outer display.
- State non-`.ready` → `ContentUnavailableView` sesuai `CameraDemoState`.

- [ ] **Step 1:** Implementasi + case router.
- [ ] **Step 2:** Build → sukses, tanpa warning Sendable baru.
- [ ] **Step 3: Cek simulator (Review Focus #5):** kedua demo → "No camera", tidak crash, toggle teleprompter disabled. Jalur kamera nyata hanya bisa dicek di device fisik — catat di commit message.
- [ ] **Step 4: Commit** — `git commit -m "feat: camera demos (live paths need physical device)"`

---

### Task 9: Mockup use case (7 layar)

**Files:**
- Create: `Duo Test/UseCases/MockData.swift`, `MailContinuityMock.swift`, `PodcastMock.swift`, `TabletopVideoMock.swift`, `AirGuitarMock.swift`, `TeleprompterMock.swift`, `PhotoGridMock.swift`, `CalculatorMock.swift`
- Modify: `Shell/UseCaseRouter.swift`

**Interfaces:**
- Consumes: `HingeGauge`, `PitchBend`, `TeleprompterAccessoryDemo`, `GridPolicy.columns`, `PlayerMock`, `UpNextMock`.
- Produces: 7 view, satu per `UseCase.id`.

Setiap mockup dibuka dari detail use case lewat `DemoLauncher` (fullScreenCover) agar bar & arrangement-nya milik window. Kontrol yang mengambang di atas media (player, kamera, kalkulator) memakai Liquid Glass; daftar dan konten scroll tidak.

Isi (data dummy, tanpa aset eksternal; SF Symbols + gradient):
- `mail`: `NavigationSplitView` inbox → email; seleksi di `@SceneStorage` supaya bertahan saat fold/unfold; Compose `.visibilityPriority(.high)`; badge unread.
- `podcast`: `ArrangementView { PlayerMock } secondary: { TranscriptMock }.arrangementViewStyle(.split.axes(.horizontal))`; toggle transcript; `ToolbarOverflowMenu` Share/Sleep timer.
- `tabletopVideo`: `ArrangementView { ControlsMock } secondary: { VideoMock }.arrangementViewStyle(.overlay)` — laptop: video atas, kontrol bawah; flat: kontrol overlay di atas video.
- `airGuitar`: senar + `HingeGauge`; pitch bend menggeser offset/warna senar.
- `teleprompter`: bungkus `TeleprompterAccessoryDemo` dengan naskah dummy.
- `photoGrid`: `LazyVGrid` kolom dari `GridPolicy.columns(width:minItemWidth: 110, hasDivision: !proxy.reservedRegions(kind: .division, options: .includeInactive).isEmpty)`. Saat division **aktif**: margin luar tetap, jarak di sekitar hinge diperbesar selebar division (grid dipecah jadi dua `LazyVGrid` per pane dari `FoldSplit.panes`). Long-press foto → `contextMenu` (foto + menu bergeser bersama oleh sistem).
- `calculator`: full-width, `.toolbarVerticalBehavior(.disabled)`, keypad digeser menjauhi bar berdasar `toolbarVerticalEdge`.

- [ ] **Step 1:** Implementasi 7 view + case router.
- [ ] **Step 2:** Build → sukses.
- [ ] **Step 3: Cek simulator** tiap mockup pada pose di `UseCase.poses`. `mail`: pilih email di inner, tutup device → outer menampilkan email yang sama. `photoGrid` (Review Focus #3): outer landscape & Split View → ≥ 1 kolom; inner → jumlah kolom genap.
- [ ] **Step 4: Commit** — `git commit -m "feat: iPhone Duo use case mockups"`

---

### Task 10: Verifikasi akhir semua pose

**Files:** tidak ada perubahan kode kecuali perbaikan temuan.

- [ ] **Step 1:** Build command baku → sukses; `... build 2>&1 | grep -c "warning:"` tidak naik dibanding setelah Task 1.
- [ ] **Step 2:** `grep -rn "UIScreen.main\|userInterfaceIdiom\|interfaceOrientation" "Duo Test" | grep -v "Core/Catalog.swift"` → nol hasil.
- [ ] **Step 3a: Audit desain & kode** terhadap bagian Design System:
  `grep -rnE "foregroundColor\(|cornerRadius\(|NavigationLink\(destination|tabItem\(|UIImpactFeedbackGenerator|Font\.system\(size|\.font\(\.system\(size" "Duo Test"` → nol hasil (kecuali `.font(.system(size:))` untuk ukuran simbol dekoratif besar, dicatat alasannya).
  Cek manual: Reduce Motion ON → displacement & arrangement cross-fade tanpa pantul; Reduce Transparency ON → kontrol glass tetap terbaca; Increase Contrast ON; dark mode; Dynamic Type terbesar.
- [ ] **Step 3:** Matriks di simulator iPhone Duo: closed portrait, closed landscape, open portrait, open landscape, book fold, laptop fold, tent, Split View 50/50 kiri & kanan, PiP di-pin di atas (app resize vertikal) — buka satu demo per area dan ketujuh use case. Kriteria: tidak ada kontrol di lipatan, tidak ada konten tertutup bar vertikal, tidak ada crash.
- [ ] **Step 4:** Commit perbaikan bila ada: `git commit -m "fix: pose matrix findings"`.
