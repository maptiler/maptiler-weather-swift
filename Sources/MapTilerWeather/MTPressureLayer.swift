//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTPressureLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// A layer that displays atmospheric pressure data.
///
/// The PressureLayer shows the atmospheric pressure in millibar (mbar) or hectopascal (hPa).
/// Forecast for air pressure at mean sea level.
public class MTPressureLayer: MTIntensityLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "PressureLayer"
    }

    /// Initializes a new pressure layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier. Defaults to "MapTiler Pressure".
    ///   - colorRamp: Color ramp used to represent the weather data.
    ///     Defaults to ``MTWeatherColorRampPreset/pressure2``.
    ///   - opacity: The opacity at which the weather data will be drawn. Defaults to 1.
    ///   - smooth: Whether or not the colorramp must be smooth. Defaults to true.
    public init(
        identifier: String = "MapTiler Pressure",
        colorRamp: MTWeatherColorRamp = MTWeatherColorRamp(preset: .pressure2),
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

    /// Picks pressure data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: Pressure value in hPa (mbar), or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTPressureValue? {
        let result: [String: Any]? = try await super.pickAt(lng: lng, lat: lat)
        guard let dict = result else {
            return nil
        }

        if let value = dict.getDouble("value") {
            return MTPressureValue(value: value)
        }

        return nil
    }

}

/// Pressure value at a given location.
public struct MTPressureValue: Sendable {
    /// Pressure in hPa (hectopascal) or mbar (millibar).
    public let value: Double
}
