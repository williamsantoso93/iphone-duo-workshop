# Catatan Tech Talks iPhone Duo

Ringkasan 6 tech talk Apple (https://developer.apple.com/iphone-duo/). Video lokal: `../Tech Talks/tech-talks-1114xx_sd.mp4`. Group Lab (meet-with-apple 285–287) tidak punya transkrip.

| ID | Judul | Fokus |
|----|-------|-------|
| 111466 | Design for iPhone Duo | Prinsip desain, pose, bar di samping, fold |
| 111461 | Prepare your app for iPhone Duo | SDK, size class, safe area, `ReservedRegion`, skill App Resizability |
| 111462 | Raise the bar with iPhone Duo | Bar vertikal, urutan item, `AxisBehavior`, overflow |
| 111463 | Strike a pose with adaptive layouts | Displacement, reserved region API, `ArrangementView` |
| 111464 | Leverage multiple displays and scenes | Hinge API, multitasking, multi-scene, scene accessory |
| 111465 | Build a great camera experience | Virtual Front Camera, direction coordinator, preview |

---

## 1. Model mental device

- **Outer display** (tertutup): lebih lebar & pendek dari iPhone biasa. Kamera + status bar + Dynamic Island pindah ke **sisi kanan**; area kanan itu juga jadi tempat bar app (tab bar, toolbar, back).
- **Inner display** (terbuka): layar iPhone terbesar. Landscape → bar tetap di samping. **Portrait inner = satu-satunya pose dengan bar horizontal.**
- **Pose**: book (setengah lipat), laptop/tabletop (di meja, layar bawah = kontrol), tent (berdiri di sisi).
- **Fold** (setengah lipat): sistem menggeser konten & elemen interaktif menjauhi lengkungan tengah. Konten scroll boleh lewat fold; tombol jangan.
- **Split View 50/50** via gesture home (drag app ke samping). App di kiri → bar pindah ke tepi kiri.
- **PiP bisa di-pin di atas**; app di bawahnya resize vertikal (dan membesar ke setengah layar saat dilipat).
- **Size class**:
  - Outer portrait: H compact / V regular. Outer landscape: compact / compact.
  - Inner: regular / regular.
- Inner display **tidak menghormati** supported interface orientations (app di-scale). `UIRequiresFullScreen` tetap dihormati, tapi app tetap resize saat buka/tutup.

## 2. Tingkat adopsi SDK

| Build dengan | Hasil |
|---|---|
| SDK lama | Outer: pakai area kiri status bar. Inner: ukuran/aspek familiar (letterbox). |
| iOS 27 SDK | Inner: app melebar ke kiri area status bar. |
| **iOS 27.1 SDK (Xcode 27.1)** | Full screen sampai tepi; nav/toolbar button tersusun vertikal di bawah status bar. |

Test: simulator **iPhone Duo** di **Device Hub**; tombol bawah untuk open/close/rotate/fold. Uji Split View dengan drag home indicator ke kiri/kanan.

## 3. Aturan layout (wajib)

- Desain untuk **size class**, bukan pose/device. Hindari fixed width, breakpoint, metrik spesifik layar.
- **Jangan** pakai `userInterfaceIdiom` / `interfaceOrientation` untuk keputusan layout.
- **Jangan** pakai `UIScreen.main` (ambigu di 2 display, akan deprecated). Pakai environment / trait collection / scene bounds; kalau perlu screen → ambil dari `windowScene`.
- Sudut layar: `ConcentricRectangle` (SwiftUI), `UICornerConfiguration` (UIKit).
- **Safe area & layout margin asimetris** — jangan asumsikan inset kiri = kanan. Tangani tiap sisi terpisah.
- Foreground interaktif → di dalam safe area. Background full-bleed → `ignoresSafeArea` / view bounds.
- Bar horizontal memberi inset atas/bawah; bar vertikal memberi inset leading/trailing.
- Konten "center" di outer display biasanya perlu offset (otomatis kalau align ke horizontal safe area inset). Full-screen center hanya untuk UI imersif non-scroll yang tidak tertutup kontrol.
- Fungsi & hierarki **sama** di semua pose. Pose tabletop boleh layout khusus (media atas, kontrol bawah) tapi kontrol tetap lengkap.
- Inner display jangan cuma iPhone yang di-stretch: pakai split view, layout 2 kolom, atau tab bar → **sidebar** (untuk app padat informasi).
- Skill **App Resizability** (Xcode 27.1, dulu "app modernization") untuk audit otomatis — SwiftUI + UIKit.

## 4. Navigasi & container standar

- `NavigationSplitView` / `UISplitViewController`: collapse ke stack saat tertutup; kolom tiled/overlay saat terbuka.
- `TabView` / `UITabBarController`: tab vertikal saat perlu. Sidebar di inner: SwiftUI `.defaultTabBarPlacement(.sidebar)`, UIKit preferred placement `.sidebar`.
- Sheet: outer → tombol bisa vertikal; inner → centered, bar horizontal. Setengah lipat → sheet geser keluar fold.
- Popover, context menu, alert, menu, toolbar button → otomatis **fold avoidance**. Pakai komponen sistem sebisa mungkin.

## 5. Bar vertikal (Raise the bar)

**Opt-in:** rebuild dengan SDK terbaru + pakai bar milik container (`.toolbar` + `NavigationStack`/`NavigationSplitView`; UIKit: toolbar items di VC dalam `UINavigationController`/`UITabBarController`). `UIToolbar`/`UINavigationBar`/`UITabBar` custom **tidak ikut**.

- Bayangkan nav + toolbar + tab bar diputar 90° jadi satu stack vertikal bersama.
- Hanya container yang menempel tepi display yang dapat bar vertikal. Split view: hanya **detail column**. Inspector tidak dapat bar vertikal sendiri.
- Sheet inner dengan `preferredPlacement`: kiri → tanpa bar vertikal, kanan → dapat.
- Bar terikat hardware → tetap di sisi yang sama di bahasa RTL.
- **Urutan atas → bawah**: navigasi utama (back/close) → aksi prominent (done) → sisanya per grup (spacer vertikal memisah grup top/bottom).
  - Close custom: SwiftUI `cancellationAction`; UIKit leading item dengan `leftItemSupplementsBackButton = false`.
  - Prominent: SwiftUI `topBarPinnedTrailing`; UIKit `pinnedTrailingGroup`.
  - Toolbar atas → atas stack; toolbar bawah → bawah stack; tab bar tetap bawah.
- **Konten item**: bar vertikal lebar tetap → cocok untuk symbol-only. Selalu beri **title + icon** (`Label` / `UIBarButtonItem` title+image). Item teks-saja, segmented control, custom view kompleks → tetap horizontal di nav bar.
- **`AxisBehavior`**: `.horizontalOnly` untuk item yang berganti symbol↔teks (mis. custom Select); `.verticalPreferred` untuk custom view yang punya representasi vertikal. Edit button sistem sudah otomatis horizontal.
- Kurangi item teks+gambar: pakai **badge** (iOS 26) ganti angka inline. Teks yang membawa info penting (mis. total harga) → biarkan horizontal.
- Keyboard accessory bar tetap menempel keyboard.
- Custom view vertikal: muat di lebar tetap atau punya layout vertikal; baca `toolbarVerticalEdge` (environment/trait; nil = tidak vertikal). Pastikan legible saat Reduce Transparency (bar dapat background). Flexible spacer = 0 di sumbu vertikal; fixed spacer tetap.
- **Overflow** (sering di outer landscape, keyboard, PiP):
  - `toolbarCompressionBehavior`: default toolbar mengecil dulu (app navigasi); app task-oriented → tab bar mengecil dulu.
  - Satukan overflow custom ke menu sistem: `ToolbarOverflowMenu` (SwiftUI) / `additionalOverflowItems` (UIKit). Ellipsis hanya untuk overflow.
  - `visibilityPriority`: default overflow dari bawah ke atas; set high/low/custom per grup lalu per item. Aksi sering dipakai & item ber-badge → prioritas tinggi.
- **Matikan bar vertikal** untuk app single-page bottom-heavy (gaya kalkulator) atau sheet dengan 1 item: `toolbarVerticalBehavior` / `preferredVerticalBarBehavior`.

## 6. Reserved region, displacement, arrangement (Strike a pose)

**Reserved region** = area hardware yang membentuk ruang: fold (hinge) dan kamera (outer selalu ada; inner FaceTime under-display saat aktif).

- SwiftUI: `GeometryProxy.reservedRegion(...)` dari `GeometryReader` / `onGeometryChange`. UIKit: `UIView.reservedRegion(...)` (`UIViewReservedRegion`). Ambil `frame`.
- Jenis: **division** (fold — membagi area) dan **occlusion** (kamera inner — menutupi area kecil).
- Aktif/inaktif: default hanya aktif; opsi `includeInactive`. Fold aktif hanya saat dilipat (flat = lebar 0). Kamera aktif saat kamera menyala.
- Pakai region inaktif untuk keputusan tingkat tinggi (mis. grid pilih jumlah kolom **genap** kalau ada division).
- Cocok untuk custom bar / UI edge-to-edge.

**Displacement** = geser/resize elemen yang sudah ada sesuai ruang saat dilipat.
- Scope sesuai konten: elemen independen geser sendiri; elemen yang terkait geser bersama (mis. foto + context menu-nya). Jangan geser terlalu jauh dari sumber.
- Konten scroll kontinu (artikel, feed, list) **tidak** di-displace.
- Tujuan menentukan region: book → alert ke trailing (dekat outer display); tabletop → info ke region atas, kontrol tap ke region bawah. Tetap kontekstual (search field mengikuti view yang dicari).
- Split view app → sistem bikin 50/50. Grid → pertahankan margin luar, perbesar jarak di sekitar hinge.

**Arrangement** (iOS 27.1) = layout container 2 view (primary + secondary) di antara navigation container dan content container. Input: size class, aspect ratio, division aktif → output: tampil/tidak + frame.
- SwiftUI `ArrangementView(primary, secondary)` + `.arrangementViewStyle(...)`; UIKit `UIArrangementViewController` + `updateArrangement` (`UISplitArrangement`, dll).
- **Split** (default): side by side; horizontal kalau lebar > tinggi, vertikal kalau sebaliknya. `.axes(...)` membatasi; kalau tidak bisa split di sumbu primer → hanya primary.
- **Overlay**: tumpuk atas/bawah; saat dilipat jadi berdampingan. Baca `overlayArrangementZIndex` (UIKit: `stateForViewPlacement` → `zIndex`) untuk collapse/expand.
- Pilih: sudah pakai HStack/VStack → split; ZStack → overlay. Hubungan main-detail (tidak boleh tertutup) → split; foreground/background (konten bisa scroll di bawah kontrol) → overlay.
- **Jangan** taruh navigation container di dalam ArrangementView; **jangan** taruh ArrangementView di dalam List/ScrollView.

## 7. Hinge, multitasking, multi-scene (Leverage displays)

- **Hinge**: SwiftUI `.onHingeChange { old, new in }`, UIKit `UIHingeInteraction`. Status diskrit: closed / partially open / fully open + sudut kontinu. `hinge == nil` → device tanpa hinge. Pakai untuk **interaksi/efek** (contoh: whammy bar gitar), **bukan layout** (layout → region/arrangement). Reset state saat tidak membaca sudut.
- **Multitasking**: semua app ikut side-by-side & stack video+app. Tangani sama via size class & scene geometry.
- **Multiple scenes**: dukungan iPad ikut ke Duo. Window baru **hanya di inner display** (outer tidak bisa) → tangani error request scene; pakai `UIWindowSceneActivationAction` (otomatis hilang saat tidak tersedia).
- **Scene accessories**: konten tambahan di display lain. Ketersediaan diatur sistem (default on, bisa toggle) → observasi.
  - **`CameraCaptureAccessory`**: UI di outer display sementara UI utama kamera di inner. Syarat: app full screen di inner + sesi kamera aktif. Daftarkan di view yang sama dengan UI kamera via `.sceneAccessory(...)`; `onAvailabilityChange` untuk disable kontrol saat tidak tersedia (mis. device tertutup). Contoh: teleprompter.

## 8. Kamera (Build a great camera experience)

- 2 kamera depan, keduanya **sensor kotak ultrawide**: **outer ultrawide** (sampai 4K/120fps) dan **inner ultrawide** (under-display pertama; 1080p/60fps).
- `AVCaptureDevice.DiscoverySession` posisi `.front` + wide/ultrawide → dapat **Virtual Front Camera**: otomatis switch inner (terbuka) ↔ outer (tertutup). Batas: fitur bersama saja (maks 1080p/60fps, **tanpa depth**).
- Device type individual: built-in **outer ultrawide** / **inner ultrawide** → kemampuan penuh + depth, tapi app wajib switch sendiri.
- `position` statis (`.front`) tidak cukup — di Duo kamera "front" bisa menghadap menjauh. Pakai **`AVCaptureDeviceDirectionCoordinator`** (AVKit): butuh UIView app, device types, change handler. Melaporkan forward/backward relatif terhadap **view** (display tempat view berada). Flip device terbuka → kamera belakang jadi forward-facing (selfie kamera belakang).
- Dua display sekaligus (scene accessory) → **satu coordinator per view**.
- Coordinator `@MainActor`; handler **jangan** panggil AVFoundation langsung. Ia memberi `AVCaptureDeviceDescriptor` (Sendable) → kirim ke camera actor.
- Di handler: rekonfigurasi `AVCaptureSession` ke kamera forward-facing, atur mirroring (kamera belakang forward → mirror preview), update UI.
- Preview: kamera belakang di inner → ada ruang sisa; offset preview + kelompokkan kontrol, atau fill (`videoGravity`). Kamera depan ultrawide → `dynamicAspectRatio` untuk landscape penuh di inner.
- Rotasi: pakai **rotation coordinator** (update saat pindah display), lalu matikan camera-sensor-orientation compensation untuk performa.
- Docs: "Choosing a Camera by the Direction it Faces", "Supporting Device Rotation in Your Camera App".

---

## Checklist kesiapan

- [ ] Build dengan Xcode 27.1 / iOS 27.1 SDK; tes di simulator iPhone Duo (open/close/rotate/fold, Split View kiri & kanan, PiP).
- [ ] Hapus `UIScreen.main`, cek idiom/orientation untuk layout → size class/trait/scene.
- [ ] Safe area & margin asimetris; foreground dalam safe area.
- [ ] Bar dari container sistem; semua item punya title + icon; urutan atas→bawah benar.
- [ ] `AxisBehavior` untuk item custom; badge ganti teks hitungan.
- [ ] `visibilityPriority`, `toolbarCompressionBehavior`, overflow menu sistem.
- [ ] Inner display: split / 2 kolom / sidebar.
- [ ] Audit layout centered → displacement / `ArrangementView` / `reservedRegion`.
- [ ] Fitur sama di semua pose.
- [ ] Multi-scene: tangani window hanya di inner.
- [ ] Kamera: virtual front vs individual + direction coordinator; rotation coordinator.
- [ ] Jalankan skill App Resizability.
