//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTColoringFragment.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// Base class for all coloring fragments.
public class MTColoringFragment: @unchecked Sendable, Codable {
    /// Type of the coloring fragment.
    public let type: String

    fileprivate init(type: String) {
        self.type = type
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }

    enum CodingKeys: String, CodingKey {
        case type
    }

    /// Helper to decode polymorphic fragments.
    static func decode(from decoder: Decoder) throws -> MTColoringFragment {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "gradient":
            return try MTGradientColoringFragment(from: decoder)
        default:
            return try MTColoringFragment(from: decoder)
        }
    }
}

/// A coloring fragment that uses a color gradient.
public final class MTGradientColoringFragment: MTColoringFragment {
    /// Decoder options for reading raw data.
    public var decode: MTDecoderOptions

    /// Color stops for the gradient.
    public var stops: [MTColorRampStop]

    /// Whether the gradient should be smooth.
    public var smooth: Bool

    /// Overall opacity of the fragment.
    public var opacity: Double

    public init(
        decode: MTDecoderOptions,
        stops: [MTColorRampStop],
        smooth: Bool = true,
        opacity: Double = 1.0
    ) {
        self.decode = decode
        self.stops = stops
        self.smooth = smooth
        self.opacity = opacity
        super.init(type: "gradient")
    }

    enum CodingKeys: String, CodingKey {
        case decode
        case stops
        case smooth
        case opacity
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        decode = try container.decode(MTDecoderOptions.self, forKey: .decode)
        stops = try container.decode([MTColorRampStop].self, forKey: .stops)
        smooth = try container.decode(Bool.self, forKey: .smooth)
        opacity = try container.decode(Double.self, forKey: .opacity)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(decode, forKey: .decode)
        try container.encode(stops, forKey: .stops)
        try container.encode(smooth, forKey: .smooth)
        try container.encode(opacity, forKey: .opacity)
    }
}
