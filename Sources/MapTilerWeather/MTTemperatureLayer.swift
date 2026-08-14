//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTTemperatureLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// A layer that displays atmospheric temperature.
///
/// The TemperatureLayer shows the atmospheric temperature in centigrade (degree Celcius (°C)).
/// Forecast for temperatures at 2 m above ground.
public class MTTemperatureLayer: MTWeatherLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "TemperatureLayer"
    }

    /// Initializes a new temperature layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier. Defaults to "MapTiler Temperature".
    ///   - colorRamp: Color ramp used to represent the weather data.
    ///     Defaults to ``MTWeatherColorRampPreset/temperature2``.
    ///   - opacity: The opacity at which the weather data will be drawn. Defaults to 1.
    ///   - smooth: Whether or not the colorramp must be smooth. Defaults to true.
    public init(
        identifier: String = "MapTiler Temperature",
        colorRamp: MTWeatherColorRamp = MTWeatherColorRamp(preset: .temperature2),
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

    /// Picks temperature data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: Temperature value, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTTemperatureValue? {
        guard let dict = try await super.pickAt(lng: lng, lat: lat) else {
            return nil
        }

        if let value = dict["value"] as? Double,
            let valueImperial = dict["valueImperial"] as? Double {
            return MTTemperatureValue(value: value, valueImperial: valueImperial)
        }

        return nil
    }
}

/// Temperature value at a given location.
public struct MTTemperatureValue: Sendable {
    /// Temperature in degree Celcius (°C).
    public let value: Double

    /// Temperature in degree Farenheit (°F).
    public let valueImperial: Double
}
