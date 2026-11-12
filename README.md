# iPhone Duo Workshop

Workshop material for **"Develop App for iPhone Duo using SwiftUI"**: a small Landmarks app that adapts to the foldable iPhone Duo, plus notes on Apple's six iPhone Duo tech talks.

## Requirements

- Xcode 27.1 or later
- iOS 27.1 SDK (most iPhone Duo APIs need it)
- An iPhone Duo simulator

## Getting started

1. Clone the repository.
2. Open `Duo Workshop/Duo Workshop.xcodeproj`.
3. Select the **Duo Workshop** scheme and an iPhone Duo simulator, then run.

The app loads its photos from Unsplash, so it needs a network connection.

## Branches

| Branch | Contents |
| --- | --- |
| `main` | Starter project: the Landmarks model, example data, and a plain list. Start the workshop here. |
| `final` | Finished project, for reference. |

## What the workshop builds

Starting from a list of landmarks, the finished app on `final` adds:

- **Tabs** — a `TabView` with five tabs, one of them with the prominent role.
- **Adaptive browsing** — a list by default, and a grid when both size classes are regular.
- **Toolbars that follow the bar's axis** — `.axisBehavior(_:)` on toolbar items.
- **A detail screen built with `ArrangementView`** — a map and a landmark summary in a split arrangement, with a hero image that extends under the top safe area.

## Project structure

```
Duo Workshop/
  Duo Workshop.xcodeproj
  Duo Workshop/
    MyApp.swift              App entry point
    Model/
      Landmark.swift         Landmark and Continent types
      LandmarkData.swift     Example landmarks
    View/
      ContentView.swift      Tabs, landmark browser, toolbar
```

`View/LandmarkDetailScreen.swift` exists on `final` only.

## Documentation

- [iPhone Duo Developer Guide](docs/iphone-duo-developer-guide.md)
- [Tech talk notes](docs/iphone-duo-tech-talks-notes.md)
- [Prepare for iPhone Duo](https://developer.apple.com/iphone-duo/prepare/)

Code in the guide is adapted from the talks' listings. Check signatures against the SDK before shipping.

## Credits

Photos courtesy of [Unsplash](https://unsplash.com), used under the Unsplash License.
