//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  WeatherLayerValueCommand.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// Command to call a method on a weather layer and return its value.
internal struct WeatherLayerValueCommand: MTValueCommand {
    let layerId: String
    let methodName: String

    func toJS() -> JSString {
        return """
        (function() {
            var styleLayer = map.getLayer("\(layerId)");
            var layer = styleLayer ? (styleLayer.implementation || styleLayer) : null;
            if (layer && typeof layer.\(methodName) === 'function') {
                return layer.\(methodName)();
            }
            return null;
        })();
        """
    }
}
