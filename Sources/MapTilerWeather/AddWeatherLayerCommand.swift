//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddWeatherLayerCommand.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

internal struct AddWeatherLayerCommand: MTCommand {
    public let layer: MTWeatherLayer
    public let beforeId: String?

    public init(layer: MTWeatherLayer, beforeId: String? = nil) {
        self.layer = layer
        self.beforeId = beforeId
    }

    public func toJS() -> JSString {
        let encoder = JSONEncoder()

        guard let layerData = try? encoder.encode(layer),
            let layerJSONString = String(data: layerData, encoding: .utf8) else {
            return ""
        }

        let beforeIdArg = beforeId != nil ? "'\(beforeId!)'" : "undefined"
        let jsClassName = layer.jsClassName

        return """
        (function() {
            function tryAddLayer(retries) {
                var weatherNS = window.\(MTWeatherBridge.moduleObject) || window.maptilerweather;

                if (!weatherNS) {
                    if (retries > 0) {
                        setTimeout(function() { tryAddLayer(retries - 1); }, 100);
                        return;
                    }
                    console.error(
                        "MapTiler Weather: \(MTWeatherBridge.moduleObject) not found. " +
                        "Make sure the module is correctly registered and loaded."
                    );
                    return;
                }

                var options = \(layerJSONString);

                if (options.colorramp) {
                    options.colorramp = new weatherNS.ColorRamp(options.colorramp);
                }
                // Remove properties not expected by the weather layer options
                delete options.type;
                delete options.source;
                delete options.visibility;

                map.addLayer(new weatherNS.\(jsClassName)(options), \(beforeIdArg));
            }
            tryAddLayer(10);
        })();
        """
    }
}
