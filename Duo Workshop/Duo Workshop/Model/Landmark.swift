//
//  File.swift
//  Duo Workshop
//
//  Created by William Santoso on 12/11/26.
//

import Foundation
import MapKit

/// A notable place people can browse, favorite, and add to collections.
nonisolated struct Landmark: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let continent: Continent
    let description: String
    let latitude: Double
    let longitude: Double
    /// Visible map span in degrees around the landmark.
    let span: Double
    /// Optional Apple Maps place identifier, for richer map lookups.
    let placeID: String?
    /// Full-size hero image hosted on Unsplash.
    let imageURL: URL

    /// Smaller version of `imageURL` for list rows and grid cells.
    var thumbnailURL: URL { imageURL.unsplashResized(width: 400) }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var locationCoordinate: CLLocationCoordinate2D { coordinate }

    var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        )
    }

    var formattedCoordinates: String {
        let lat = latitude.formatted(.number.precision(.fractionLength(4)))
        let lon = longitude.formatted(.number.precision(.fractionLength(4)))
        return "\(lat), \(lon)"
    }
}

nonisolated extension URL {
    /// Builds an Unsplash CDN URL for a photo ID, e.g. `"1600520611035-84157ad4084d"`.
    static func unsplash(_ photoID: String, width: Int = 1600) -> URL {
        URL(string: "https://images.unsplash.com/photo-\(photoID)?w=\(width)&q=80&auto=format&fit=crop")!
    }

    /// Returns this Unsplash URL with its `w` query item replaced.
    func unsplashResized(width: Int) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        var items = components.queryItems?.filter { $0.name != "w" } ?? []
        items.append(URLQueryItem(name: "w", value: String(width)))
        components.queryItems = items
        return components.url ?? self
    }
}

/// Continents used to group landmarks in the browsing UI.
nonisolated enum Continent: String, CaseIterable, Identifiable, Hashable, Sendable {
    case africa = "Africa"
    case antarctica = "Antarctica"
    case asia = "Asia"
    case australiaOceania = "Australia/Oceania"
    case europe = "Europe"
    case northAmerica = "North America"
    case southAmerica = "South America"

    var id: String { rawValue }

    var name: LocalizedStringResource {
        switch self {
        case .africa: "Africa"
        case .antarctica: "Antarctica"
        case .asia: "Asia"
        case .australiaOceania: "Australia/Oceania"
        case .europe: "Europe"
        case .northAmerica: "North America"
        case .southAmerica: "South America"
        }
    }
}
