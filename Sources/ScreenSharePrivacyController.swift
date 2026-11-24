import AppKit
import ScreenCaptureKit

/// Reference implementation of opt-in macOS screen-sharing exclusion and
/// self-excluding ScreenCaptureKit display filters.
@MainActor
public enum ScreenSharePrivacyController {
    /// Toggle window-server capture exclusion across all application windows.
    /// Keep `hiddenFromShare = false` by default so normal Dock, Command-Tab,
    /// and collaborative screenshot workflows behave as expected.
    public static func setHiddenFromScreenShare(_ hiddenFromShare: Bool) {
        NSApp.setActivationPolicy(hiddenFromShare ? .accessory : .regular)

        for window in NSApp.windows {
            apply(to: window, hiddenFromShare: hiddenFromShare)
        }

        if !hiddenFromShare {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    /// Re-apply to dynamically presented SwiftUI sheets/popovers while active.
    public static func apply(to window: NSWindow, hiddenFromShare: Bool) {
        window.sharingType = hiddenFromShare ? .none : .readOnly
        window.level = hiddenFromShare ? .floating : .normal

        if hiddenFromShare {
            window.collectionBehavior.insert([.canJoinAllSpaces, .fullScreenAuxiliary])
        } else {
            window.collectionBehavior.remove([.canJoinAllSpaces, .fullScreenAuxiliary])
        }
    }

    /// Build an SCContentFilter for the primary display that omits this app's
    /// own floating windows, preventing hall-of-mirrors recursion in vision captures.
    public static func makeSelfExcludingDisplayFilter() async throws -> SCContentFilter {
        let shareable = try await SCShareableContent.excludingDesktopWindows(
            false,
            onScreenWindowsOnly: true
        )
        guard let display = shareable.displays.first else {
            throw NSError(domain: "ScreenSharePrivacy", code: 1)
        }
        let bundleID = Bundle.main.bundleIdentifier
        let ownApps = shareable.applications.filter { $0.bundleIdentifier == bundleID }
        return SCContentFilter(
            display: display,
            excludingApplications: ownApps,
            exceptingWindows: []
        )
    }
}
