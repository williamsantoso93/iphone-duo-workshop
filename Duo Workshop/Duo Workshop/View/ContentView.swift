//
//  File.swift
//  Duo Workshop
//
//  Created by William Santoso on 12/11/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.toolbarVerticalEdge) var toolbarVerticalEdge
    @State private var landmarks: [Landmark] = Landmark.exampleData

    var body: some View {
        TabView {
            Tab("Landmark", systemImage: "mountain.2.fill") {
                NavigationStack {
                    LandmarkBrowser(landmarks: landmarks)
                    .navigationDestination(for: Landmark.self) { landmark in
                        LandmarkDetailScreen(landmark: landmark)
                    }
                    .navigationTitle("Landmarks")
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button("Favorite", systemImage: "heart") { }
                            Button("Share", systemImage: "square.and.arrow.up") { }
                        }
                        .axisBehavior(.verticalPreferred)

                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Map", systemImage: "map") { }
                        }
                        .axisBehavior(.horizontalOnly)
                    }
                }
            }

            Tab("Map", systemImage: "map") {
                ContentUnavailableView("Map", systemImage: "map")
            }

            Tab("Favorites", systemImage: "heart") {
                ContentUnavailableView("Favorites", systemImage: "heart")
            }

            Tab("Collections", systemImage: "square.grid.2x2") {
                ContentUnavailableView("Collections", systemImage: "square.grid.2x2")
            }

            Tab("Add", systemImage: "plus", role: .prominent) {
                ContentUnavailableView("Add", systemImage: "plus")
            }
        }
    }
}

/// Sample use of `toolbarVerticalEdge`: a custom toolbar label that adapts to the bar's axis.
private struct MapToolbarLabel: View {
    /// `nil` while the bar is horizontal; `.leading` or `.trailing` while it is vertical.
    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge

    var body: some View {
        if toolbarVerticalEdge == nil {
            // Horizontal bar: room for icon and title.
            Label("Map", systemImage: "map")
                .labelStyle(.titleAndIcon)
        } else {
            // Vertical bar: fixed narrow width, icon only.
            Label("Map", systemImage: "map")
                .labelStyle(.iconOnly)
        }
    }
}

/// Shows landmarks as a grid when both size classes are regular, and as a list otherwise.
private struct LandmarkBrowser: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    let landmarks: [Landmark]

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]

    var body: some View {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(landmarks) { landmark in
                        NavigationLink(value: landmark) {
                            LandmarkGridCell(landmark: landmark)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        } else {
            List(landmarks) { landmark in
                NavigationLink(value: landmark) {
                    AsyncImage(url: landmark.thumbnailURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(.rect(cornerRadius: 16))

                    Text(landmark.name)
                }
            }
        }
    }
}

private struct LandmarkGridCell: View {
    let landmark: Landmark

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(.quaternary)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    AsyncImage(url: landmark.thumbnailURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .clipShape(.rect(cornerRadius: 16))

            Text(landmark.name)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
}

#Preview {
    ContentView()
}

