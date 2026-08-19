//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTRadarLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// A layer that displays atmospheric radar reflectivity.
///
/// The RadarLayer shows the atmospheric radar reflectivity in radar reflectivity factor (dBZ).
/// Forecast for maximum composite radar reflectivity value.
public class MTRadarLayer: MTWeatherLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "RadarLayer"
    }

    /// Initializes a new radar layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier. Defaults to "MapTiler Radar".
    ///   - colorRamp: Color ramp used to represent the weather data.
    ///     Defaults to ``MTWeatherColorRampPreset/radar``.
    ///   - opacity: The opacity at which the weather data will be drawn. Defaults to 1.
    ///   - smooth: Whether or not the colorramp must be smooth. Defaults to true.
    public init(
        identifier: String = "MapTiler Radar",
        colorRamp: MTWeatherColorRamp = MTWeatherColorRamp(preset: .radar),
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

    /// Picks radar data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: Radar reflectivity value in dBZ, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTRadarValue? {
        guard let dict = try await super.pickAt(lng: lng, lat: lat) else {
            return nil
        }

        if let value = dict.getDouble("value") {
            return MTRadarValue(value: value)
        }

        return nil
    }

}

/// Radar reflectivity value at a given location.
public struct MTRadarValue: Sendable {
    /// Radar reflectivity in dBZ.
    public let value: Double
}
