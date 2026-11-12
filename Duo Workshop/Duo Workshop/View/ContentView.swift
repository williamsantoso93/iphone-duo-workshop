//
//  File.swift
//  Duo Workshop
//
//  Created by William Santoso on 12/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var landmarks: [Landmark] = Landmark.exampleData

    var body: some View {
        NavigationStack {
            List(landmarks) { landmark in
                HStack {
                    AsyncImage(url: landmark.imageURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text(landmark.name)
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

#Preview {
    ContentView()
}

