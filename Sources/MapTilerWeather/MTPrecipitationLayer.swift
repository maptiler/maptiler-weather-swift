//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTPrecipitationLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// A layer that displays precipitation data.
public class MTPrecipitationLayer: MTWeatherLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "PrecipitationLayer"
    }

    /// Initializes a new precipitation layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier. Defaults to "MapTiler Precipitation".
    ///   - colorRamp: Color ramp used to represent the weather data.
    ///     Defaults to ``MTWeatherColorRampPreset/precipitation``.
    ///   - opacity: The opacity at which the weather data will be drawn. Defaults to 1.
    ///   - smooth: Whether or not the colorramp must be smooth. Defaults to true.
    public init(
        identifier: String = "MapTiler Precipitation",
        colorRamp: MTWeatherColorRamp = MTWeatherColorRamp(preset: .precipitation),
        opacity: Double = 1.0,
        smooth: Bool = true
    ) {
        super.init(identifier: identifier)
        self.colorRamp = colorRamp
        self.opacity = opacity
        self.smooth = smooth
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// Picks precipitation data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: Precipitation value in mm/h, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTPrecipitationValue? {
        guard let dict = try await super.pickAt(lng: lng, lat: lat) else {
            return nil
        }

        func getDouble(_ key: String) -> Double? {
            if let val = dict[key] as? Double { return val }
            if let val = dict[key] as? Int { return Double(val) }
            if let val = dict[key] as? Float { return Double(val) }
            return nil
        }

        if let value = getDouble("value") {
            return MTPrecipitationValue(value: value)
        }

        return nil
    }
}

/// Precipitation value at a given location.
public struct MTPrecipitationValue: Sendable {
    /// Precipitation in mm/h.
    public let value: Double
}
