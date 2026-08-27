//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTIntensityLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// The Intensity layer is a specialized implementation of a TileLayer configured
/// to display scalar weather data (like precipitation, temperature, or radar) using coloring fragments.
public class MTIntensityLayer: MTTileLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "Intensity"
    }

    /// Initializes a new intensity layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier.
    public override init(identifier: String, sourceIdentifier: String = "") {
        super.init(identifier: identifier, sourceIdentifier: sourceIdentifier)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// Picks weather data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: The weather data value at the given location as a dictionary, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTIntensityValue? {
        let result: [String: Any]? = try await super.pickAt(lng: lng, lat: lat)
        guard let dict = result else {
            return nil
        }

        if let value = dict.getDouble("value") {
            return MTIntensityValue(value: value)
        }

        return nil
    }
}

/// Intensity value at a given location.
public struct MTIntensityValue: Sendable {
    /// The decoded value.
    public let value: Double
}
