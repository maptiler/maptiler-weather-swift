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

                var before = \(beforeIdJS);

                // Adjust water opacity if inserting below water
                if (before === 'Water' || before === 'water') {
                    try {
                        map.setPaintProperty(before, 'fill-color', 'rgba(0, 0, 0, 0.4)');
                    } catch (e) {
                        console.error('Failed to set water transparency', e);
                    }
                }

                var layer = new weatherNS.\(layer.jsClassName)(options);
                \(eventListenersJS)
                map.addLayer(layer, before);
            }
            tryAddLayer(10);
        })();
        """
    }

    private var beforeIdJS: String {
        if let beforeId = beforeId {
            return "'\(beforeId)'"
        }
        return """
        (function() {
            if (map.getLayer('Water')) return 'Water';
            if (map.getLayer('water')) return 'water';
            var layers = map.getStyle().layers;
            for (var i = 0; i < layers.length; i++) {
                var id = layers[i].id.toLowerCase();
                if (id.indexOf('boundary') !== -1 || id.indexOf('border') !== -1) {
                    return layers[i].id;
                }
            }
            for (var i = 0; i < layers.length; i++) {
                if (layers[i].type === 'symbol') {
                    return layers[i].id;
                }
            }
            return undefined;
        })()
        """
    }

    private var eventListenersJS: String {
        """
        var events = ['sourceReady', 'playAnimation', 'pauseAnimation', 'tick', 'animationTimeSet'];
        events.forEach(function(eventName) {
            layer.on(eventName, function(e) {
                if (window.webkit &&
                    window.webkit.messageHandlers &&
                    window.webkit.messageHandlers.moduleHandler) {
                    var data = { layerId: "\(layer.identifier)" };
                    if (e && e.time !== undefined) {
                        data.time = e.time;
                    }
                    var payload = JSON.stringify({
                        moduleId: "maptiler-weather",
                        event: eventName,
                        data: data
                    });
                    window.webkit.messageHandlers.moduleHandler.postMessage(payload);
                }
            });
        });
        """
    }
}
