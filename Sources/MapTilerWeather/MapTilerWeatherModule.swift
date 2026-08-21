//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MapTilerWeatherModule.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// Bridge constants for the MapTiler Weather JS module
enum MTWeatherBridge {
    static let moduleObject: String = "maptilerweather"
}

/// The MapTiler Weather module. Register this with your MTMapView to enable weather functionality.
@MainActor
public class MapTilerWeatherModule: MTMapModule {

    public let id: String = "maptiler-weather"
    private weak var mapView: MTMapView?

    private let jsContent: String
    private let cssContent: String

    public init() {
        let bundle = Bundle.module

        let jsUrl = bundle.url(forResource: "maptiler-weather", withExtension: "js", subdirectory: "Resources") ??
            bundle.url(forResource: "maptiler-weather", withExtension: "js")

        if let jsUrl = jsUrl,
            let content = try? String(contentsOf: jsUrl, encoding: .utf8) {
            self.jsContent = content
            print("MapTiler Weather: Loaded bundle (\(content.count) bytes) from \(jsUrl.lastPathComponent)")
        } else {
            print("MapTiler Weather: bundle not found in resources.")
            self.jsContent = ""
        }

        let cssUrl = bundle.url(forResource: "maptiler-weather", withExtension: "css", subdirectory: "Resources") ??
            bundle.url(forResource: "maptiler-weather", withExtension: "css")

        if let cssUrl = cssUrl,
            let content = try? String(contentsOf: cssUrl, encoding: .utf8) {
            self.cssContent = content
            print("MapTiler Weather: Loaded bundle (\(content.count) bytes) from \(cssUrl.lastPathComponent)")
        } else {
            self.cssContent = ""
        }
    }

    public func onAttach(to mapView: MTMapView) {
        self.mapView = mapView
    }

    public func onMapReady() {
        guard let mapView = mapView else { return }

        Task {
            do {
                try await injectDependencies(into: mapView)
                print("MapTiler Weather: Module initialized successfully")
            } catch {
                print("MapTiler Weather: Failed to initialize module - \(error)")
            }
        }
    }

    public func onMessageReceived(_ event: String, with data: [String: Any]?) {
        guard let layerId = data?["layerId"] as? String else { return }

        // Find the layer and route the event
        Task { @MainActor in
            let targetLayers = MTWeatherLayer.activeLayers.allObjects.filter { $0.identifier == layerId }
            for layer in targetLayers {
                layer.handleEvent(event, data: data)
            }
        }
    }

    private func injectDependencies(into mapView: MTMapView) async throws {
        guard !jsContent.isEmpty else {
            print("MapTiler Weather: content is empty, skipping injection")
            return
        }

        print("MapTiler Weather: Injecting bundle (\(jsContent.count) bytes)...")

        // Use JSONEncoder to safely escape the entire JS content.
        // This avoids issues with backticks, quotes, or other characters if the bridge wraps the string.
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(jsContent),
            let escapedJS = String(data: data, encoding: .utf8) else {
            print("MapTiler Weather: Failed to escape content")
            return
        }

        // We use eval() to execute the JSON-escaped string as JavaScript
        let wrappedJS = "eval(\(escapedJS));"

        let jsCommand = MTLoadModuleBundleCommand(bundleString: wrappedJS)
        _ = try await mapView.execute(command: jsCommand)

        if !cssContent.isEmpty {
            print("MapTiler Weather: Injecting CSS bundle...")
            let cssData = try? encoder.encode(cssContent)
            if let escapedCSS = cssData.flatMap({ String(data: $0, encoding: .utf8) }) {
                let injectCSSScript = """
                (function() {
                    try {
                        if (document.getElementById('maptiler-weather-css')) return;
                        var style = document.createElement('style');
                        style.id = 'maptiler-weather-css';
                        style.type = 'text/css';
                        style.innerHTML = \(escapedCSS);
                        document.head.appendChild(style);
                        console.log("MapTiler Weather: CSS bundle injected successfully");
                    } catch (e) {
                        console.error("MapTiler Weather: CSS injection failed: " + e.message);
                    }
                })();
                """

                let cssCommand = MTLoadModuleBundleCommand(bundleString: injectCSSScript)
                _ = try await mapView.execute(command: cssCommand)
            }
        }

        print("MapTiler Weather: Dependencies injected")
    }
}
