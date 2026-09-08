//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTWindLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// A layer that displays atmospheric wind speed and direction.
///
/// The WindLayer shows the atmospheric wind speed in meter per second (m/s).
/// Forecast for speed and direction at an altitude of 10 m above ground.
public class MTWindLayer: MTParticleLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "WindLayer"
    }

    /// Initializes a new wind layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier. Defaults to "MapTiler Wind".
    ///   - colorRamp: Color ramp used to represent the weather data.
    ///     Defaults to ``MTWeatherColorRampPreset/windViridis``.
    ///   - opacity: The opacity at which the weather data will be drawn. Defaults to 1.
    ///   - smooth: Whether or not the colorramp must be smooth. Defaults to true.
    public override init(
        identifier: String = "MapTiler Wind",
        colorRamp: MTWeatherColorRamp = MTWeatherColorRamp(preset: .windViridis),
        opacity: Double = 1.0,
        smooth: Bool = true
    ) {
        super.init(identifier: identifier, colorRamp: colorRamp, opacity: opacity, smooth: smooth)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// Picks wind data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: Wind data value, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTWindValue? {
        guard let dict = try await super.pickAt(lng: lng, lat: lat) else {
            return nil
        }

        return MTWindValue(dict: dict)
    }
}

/// Wind value at a given location.
public struct MTWindValue: Sendable {
    /// Conventional 16 compass direction where the wind comes from.
    public let compassDirection: String

    /// Angular direction in degrees towards which the wind is blowing (0° North, 90° East).
    public let directionAngle: Double

    /// Wind speed in feet per second (ft/s).
    public let speedFeetPerSecond: Double

    /// Wind speed in kilometer per hour (km/h).
    public let speedKilometersPerHour: Double

    /// Wind speed in knots (nautical miles per hour).
    public let speedKnots: Double

    /// Wind speed in meters per second (m/s).
    public let speedMetersPerSecond: Double

    /// Wind speed in miles per hour (mph).
    public let speedMilesPerHour: Double

    init?(dict: [String: Any]) {
        guard
            let compassDirection = dict["compassDirection"] as? String,
            let directionAngle = dict.getDouble("directionAngle"),
            let speedFeetPerSecond = dict.getDouble("speedFeetPerSecond"),
            let speedKilometersPerHour = dict.getDouble("speedKilometersPerHour"),
            let speedKnots = dict.getDouble("speedKnots"),
            let speedMetersPerSecond = dict.getDouble("speedMetersPerSecond"),
            let speedMilesPerHour = dict.getDouble("speedMilesPerHour")
        else {
            return nil
        }

        self.compassDirection = compassDirection
        self.directionAngle = directionAngle
        self.speedFeetPerSecond = speedFeetPerSecond
        self.speedKilometersPerHour = speedKilometersPerHour
        self.speedKnots = speedKnots
        self.speedMetersPerSecond = speedMetersPerSecond
        self.speedMilesPerHour = speedMilesPerHour
    }
}
