//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  PickAtWeatherLayerCommand.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// Command to pick weather data at a specific location for a given layer.
internal struct PickAtWeatherLayerCommand: MTCommand {
    let layerId: String
    let lng: Double
    let lat: Double

    func toJS() -> JSString {
        return """
        (function() {
            var layer = map.getLayer("\(layerId)");
            if (layer && typeof layer.pickAt === 'function') {
                return layer.pickAt(\(lng), \(lat));
            }
            return null;
        })();
        """
    }
}
