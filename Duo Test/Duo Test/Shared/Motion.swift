import SwiftUI

/// The app's motion vocabulary, following Apple's fluid-interface defaults.
enum Motion {
    /// Critically damped (damping 1.0, response 0.4): the default for every layout change, including fold displacement.
    static let standard = Animation.spring(duration: 0.4, bounce: 0)
    /// A little overshoot, only after a gesture that carried momentum (a flick or drag release).
    static let momentum = Animation.spring(duration: 0.35, bounce: 0.2)
    /// Reduce Motion replacement: a short cross-fade-friendly curve with no overshoot.
    static let reduced = Animation.easeInOut(duration: 0.2)

    static func resolve(_ animation: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? reduced : animation
    }
}
