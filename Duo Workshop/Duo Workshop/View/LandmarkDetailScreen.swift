//
//  LandmarkDetailScreen.swift
//  Duo Workshop
//
//  Created by William Santoso on 12/11/26.
//

import MapKit
import SwiftUI

struct LandmarkDetailScreen: View {
    let landmark: Landmark

    var body: some View {
        // Primary holds everything essential, because the split style shows
        // only the primary view when there is no room to split.
        ArrangementView {
            LandmarkMap(landmark: landmark)
        } secondary: {
            LandmarkSummary(landmark: landmark)
        }
        .arrangementViewStyle(.split)
        .navigationTitle(landmark.name)
    }
}

private struct LandmarkSummary: View {
    let landmark: Landmark

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: landmark.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 240)
                .ignoresSafeArea(edges: [.top, .horizontal])

                VStack(alignment: .leading, spacing: 16) {
                    Text(landmark.continent.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(landmark.description)

                    Label(landmark.formattedCoordinates, systemImage: "location")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .padding(.bottom)
        }
        .ignoresSafeArea(edges: .top)
        .scrollEdgeEffectHidden()
    }
}

private struct LandmarkMap: View {
    let landmark: Landmark

    var body: some View {
        Map(initialPosition: .region(landmark.coordinateRegion)) {
            Marker(landmark.name, coordinate: landmark.coordinate)
        }
    }
}

#Preview {
    NavigationStack {
        LandmarkDetailScreen(landmark: Landmark.exampleData[0])
    }
}
