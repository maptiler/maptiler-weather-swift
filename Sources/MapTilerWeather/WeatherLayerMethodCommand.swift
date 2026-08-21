//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  WeatherLayerMethodCommand.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// Represents an argument passed to a JS method call.
internal enum WeatherCommandArgument: Sendable {
    case string(String)
    case double(Double)
    case bool(Bool)

    var jsRepresentation: String {
        switch self {
        case .string(let str):
            return "'\(str)'"
        case .double(let num):
            return "\(num)"
        case .bool(let bool):
            return bool ? "true" : "false"
        }
    }
}

/// Command to call a method on a weather layer without expecting a return value.
internal struct WeatherLayerMethodCommand: MTCommand {
    let layerId: String
    let methodName: String
    let arguments: [WeatherCommandArgument]

    func toJS() -> JSString {
        let argsCode = arguments.map { $0.jsRepresentation }.joined(separator: ", ")

        return """
        (function() {
            var styleLayer = map.getLayer("\(layerId)");
            var layer = styleLayer ? (styleLayer.implementation || styleLayer) : null;
            if (layer && typeof layer.\(methodName) === 'function') {
                layer.\(methodName)(\(argsCode));
            }
        })();
        """
    }
}
