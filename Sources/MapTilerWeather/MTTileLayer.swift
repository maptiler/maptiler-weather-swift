//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTTileLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// The TileLayer is the base class for weather layers that consist of multiple timeframes smoothly animated over time.
public class MTTileLayer: MTWeatherLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "TileLayer"
    }

    /// Initializes a new tile layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier.
    public override init(identifier: String, sourceIdentifier: String = "") {
        super.init(identifier: identifier, sourceIdentifier: sourceIdentifier)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// Adds a new timeframe/frame to the animation.
    ///
    /// - Parameters:
    ///   - time: The time of the timeframe.
    ///   - url: The URL of the tile source.
    public func addSource(time: Date, url: String) {
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "addSource",
                arguments: [.double(time.timeIntervalSince1970), .string(url)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Removes a specific timeframe.
    ///
    /// - Parameter time: The time of the timeframe to remove.
    public func removeSource(time: Date) {
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "removeSource",
                arguments: [.double(time.timeIntervalSince1970)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }
}
