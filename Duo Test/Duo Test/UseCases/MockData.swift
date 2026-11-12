import SwiftUI

/// Dummy content for the use case mockups; no external assets, only SF Symbols and gradients.
enum MockData {
    struct Email: Identifiable, Hashable {
        let id: Int
        let sender: String
        let subject: String
        let preview: String
        let time: String
        let isUnread: Bool
    }

    struct Photo: Identifiable, Hashable {
        let id: Int
        let hue: Double
        let systemImage: String
    }

    static let emails: [Email] = [
        Email(id: 1, sender: "Design Team", subject: "Fold review notes",
              preview: "We walked through every screen on the inner display and found three places where content sits in the fold.",
              time: "9:41", isUnread: true),
        Email(id: 2, sender: "Maya Chen", subject: "Tabletop video prototype",
              preview: "Set it down like a laptop and the controls move to the bottom half. Feels great on a train table.",
              time: "8:15", isUnread: true),
        Email(id: 3, sender: "Release Bot", subject: "Build 27.1 (412) is ready",
              preview: "A new build is available for testing. Vertical bars and reserved regions are enabled.",
              time: "Yesterday", isUnread: false),
        Email(id: 4, sender: "Sam Ortiz", subject: "Lunch on Thursday?",
              preview: "There's a new place near the office with outdoor seating. Want to try it?",
              time: "Yesterday", isUnread: false),
        Email(id: 5, sender: "Accessibility Guild", subject: "Reduce Motion checklist",
              preview: "Every fold transition should have a cross-fade fallback. Here's the list we use.",
              time: "Monday", isUnread: true),
        Email(id: 6, sender: "Priya Nair", subject: "Photo grid columns",
              preview: "Even column counts keep photos out of the hinge. Two panes, same count each side.",
              time: "Monday", isUnread: false),
        Email(id: 7, sender: "Calendar", subject: "Weekly sync moved",
              preview: "The weekly sync moved to Wednesday at 10:00.",
              time: "Sunday", isUnread: false),
    ]

    static let transcript: [(time: String, line: String)] = [
        ("0:00", "Welcome back to The Fold. Today we're talking about designing for two displays."),
        ("0:12", "When you open the device, your app gets a lot more room, but also a crease down the middle."),
        ("0:31", "The first rule: don't put anything important in the fold."),
        ("0:45", "Reserved regions tell you exactly where it is, in your own view's coordinates."),
        ("1:02", "For layout, reach for arrangements. They split primary and secondary content for you."),
        ("1:20", "The hinge angle is for effects and interactions, like a whammy bar."),
        ("1:38", "And on the outer display, bars can go vertical to give content more height."),
        ("1:55", "Let's look at a few apps that get this right."),
        ("2:10", "First up, a mail app that keeps your selection when you fold and unfold."),
        ("2:32", "Then a video player you can set down like a laptop."),
    ]

    static let photos: [Photo] = (0..<48).map { index in
        let symbols = ["mountain.2", "leaf", "sun.max", "cloud", "water.waves", "camera.macro", "building.2", "car"]
        return Photo(id: index, hue: Double(index % 12) / 12, systemImage: symbols[index % symbols.count])
    }
}
