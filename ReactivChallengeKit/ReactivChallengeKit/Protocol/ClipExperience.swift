//  ClipExperience.swift
//  ReactivChallengeKit
//
//  Copyright © 2025 Reactiv Technologies Inc. All rights reserved.
//

import SwiftUI

// MARK: - Journey Metadata

enum JourneyTouchpoint: String, CaseIterable, Identifiable {
    case discovery = "Discovery"
    case ticketPurchase = "Ticket Purchase"
    case theWait = "The Wait"
    case showDay = "Show Day"
    case postShow = "Post-Show"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .discovery: return "eye.fill"
        case .ticketPurchase: return "ticket.fill"
        case .theWait: return "clock.fill"
        case .showDay: return "music.mic"
        case .postShow: return "moon.stars.fill"
        }
    }

    var fanContext: String {
        switch self {
        case .discovery:
            return "Fan sees a social media post about the concert."
        case .ticketPurchase:
            return "Fan just bought tickets on Ticketmaster."
        case .theWait:
            return "Fan has tickets. Show is in 2 weeks."
        case .showDay:
            return "Fan is at the venue. Merch booths everywhere."
        case .postShow:
            return "Fan just left the show. Still buzzing."
        }
    }

    var emotion: String {
        switch self {
        case .discovery: return "Curious"
        case .ticketPurchase: return "Excited, spending mode"
        case .theWait: return "Anticipation building"
        case .showDay: return "Peak energy, impatient"
        case .postShow: return "Euphoric, nostalgic"
        }
    }
}

enum InvocationSource: String, CaseIterable, Identifiable {
    case qrCode = "QR Code"
    case nfcTag = "NFC Tag"
    case iMessage = "iMessage Link"
    case smartBanner = "Smart Banner"
    case appleMaps = "Apple Maps"
    case siri = "Siri Suggestion"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .qrCode: return "qrcode.viewfinder"
        case .nfcTag: return "wave.3.right"
        case .iMessage: return "message.fill"
        case .smartBanner: return "safari.fill"
        case .appleMaps: return "map.fill"
        case .siri: return "wand.and.stars"
        }
    }

    var triggerLabel: String {
        switch self {
        case .qrCode: return "Scan Code"
        case .nfcTag: return "Tap Tag"
        case .iMessage: return "Open Link"
        case .smartBanner: return "Tap Banner"
        case .appleMaps: return "View Place"
        case .siri: return "Suggested"
        }
    }
}

// MARK: - Protocol

/// Conform to this protocol to create your App Clip experience.
protocol ClipExperience: View {
    /// URL pattern this clip responds to. Use `:paramName` for path parameters.
    static var urlPattern: String { get }

    /// Human-readable name for this clip.
    static var clipName: String { get }

    /// One-line description of what this clip does.
    static var clipDescription: String { get }

    /// Your team name (for the submission gallery).
    static var teamName: String { get }

    /// Which concert journey touchpoint does this clip target?
    static var touchpoint: JourneyTouchpoint { get }

    /// How would this clip be invoked in the real world?
    static var invocationSource: InvocationSource { get }

    /// Initialize with the parsed invocation context.
    init(context: ClipContext)
}

extension ClipExperience {
    static var teamName: String { "Reactiv" }
    static var touchpoint: JourneyTouchpoint { .showDay }
    static var invocationSource: InvocationSource { .qrCode }
}
