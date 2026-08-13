//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTWeatherLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// Base class for all MapTiler Weather layers.
public class MTWeatherLayer: MTLayer, @unchecked Sendable, Codable {
    /// Unique layer identifier.
    public var identifier: String

    /// Type of the layer.
    public private(set) var type: MTLayerType = .weather

    /// Identifier of the source to be used for this layer.
    ///
    /// Weather layers usually manage their own sources internally, but this property
    /// is required for conformance to the ``MTLayer`` protocol.
    public var sourceIdentifier: String = ""

    /// The maximum zoom level for the layer.
    public var maxZoom: Double?

    /// The minimum zoom level for the layer.
    public var minZoom: Double?

    /// Layer to use from a vector tile source.
    ///
    /// Not typically used by weather layers.
    public var sourceLayer: String?

    /// The opacity at which the weather data will be drawn.
    /// Optional number between 0 and 1 inclusive. Defaults to 1.
    public var opacity: Double? = 1.0

    /// Whether or not the colorramp must be smooth. Defaults to true.
    public var smooth: Bool? = true

    /// Whether this layer is displayed. Defaults to .visible.
    public var visibility: MTLayerVisibility? = .visible

    /// Color ramp used to represent the weather data.
    public var colorRamp: MTWeatherColorRamp?

    /// Time for which to display the weather data.
    public var time: Date?

    /// Weak reference to the map view this layer is added to.
    internal weak var mapView: MTMapView?

    open var jsClassName: String {
        return "WeatherLayer"
    }

    /// Initializes the weather layer with an identifier and an optional source identifier.
    public init(identifier: String, sourceIdentifier: String = "") {
        self.identifier = identifier
        self.sourceIdentifier = sourceIdentifier
    }

    /// Adds the weather layer to the map.
    public func addTo(_ map: MTMapView) {
        addToMap(map)
    }

    /// Adds the layer to the map (MTMapViewContent protocol).
    ///
    /// This method is part of the ``MTMapViewContent`` protocol and allows the layer to be used
    /// within the MapTiler Map DSL.
    public func addToMap(_ mapView: MTMapView) {
        self.mapView = mapView
        Task {
            let command = AddWeatherLayerCommand(layer: self)
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Picks weather data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: The weather data at the given location as a dictionary, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> [String: Any]? {
        guard let mapView = self.mapView else {
            return nil
        }
        let command = PickAtWeatherLayerCommand(layerId: self.identifier, lng: lng, lat: lat)
        let result = try await mapView.execute(command: command)

        switch result {
        case .stringDoubleDict(let dict):
            return dict
        default:
            return nil
        }
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case type
        case source = "source"
        case maxZoom = "maxzoom"
        case minZoom = "minzoom"
        case sourceLayer = "source-layer"
        case opacity
        case smooth
        case colorRamp = "colorramp"
        case visibility
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        type = try container.decode(MTLayerType.self, forKey: .type)
        sourceIdentifier = try container.decode(String.self, forKey: .source)
        maxZoom = try container.decodeIfPresent(Double.self, forKey: .maxZoom)
        minZoom = try container.decodeIfPresent(Double.self, forKey: .minZoom)
        sourceLayer = try container.decodeIfPresent(String.self, forKey: .sourceLayer)

        opacity = try container.decodeIfPresent(Double.self, forKey: .opacity)
        smooth = try container.decodeIfPresent(Bool.self, forKey: .smooth)
        colorRamp = try container.decodeIfPresent(MTWeatherColorRamp.self, forKey: .colorRamp)

        if let visibilityRaw = try container.decodeIfPresent(String.self, forKey: .visibility) {
            visibility = MTLayerVisibility(rawValue: visibilityRaw)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(type, forKey: .type)
        try container.encode(sourceIdentifier, forKey: .source)
        try container.encodeIfPresent(maxZoom, forKey: .maxZoom)
        try container.encodeIfPresent(minZoom, forKey: .minZoom)
        try container.encodeIfPresent(sourceLayer, forKey: .sourceLayer)

        try container.encodeIfPresent(opacity, forKey: .opacity)
        try container.encodeIfPresent(smooth, forKey: .smooth)
        try container.encodeIfPresent(colorRamp, forKey: .colorRamp)
        try container.encodeIfPresent(visibility?.rawValue, forKey: .visibility)
    }
}

// MARK: - DSL Modifiers

extension MTWeatherLayer {
    /// Modifier. Sets the ``opacity``.
    @discardableResult
    public func opacity(_ value: Double) -> Self {
        self.opacity = value
        return self
    }

    /// Modifier. Sets the ``smooth``.
    @discardableResult
    public func smooth(_ value: Bool) -> Self {
        self.smooth = value
        return self
    }

    /// Modifier. Sets the ``visibility``.
    @discardableResult
    public func visibility(_ value: MTLayerVisibility) -> Self {
        self.visibility = value
        return self
    }

    /// Modifier. Sets the ``colorRamp``.
    @discardableResult
    public func colorRamp(_ value: MTWeatherColorRamp) -> Self {
        self.colorRamp = value
        return self
    }

    /// Modifier. Sets the ``time``.
    @discardableResult
    public func time(_ value: Date) -> Self {
        self.time = value
        return self
    }

    /// Modifier. Sets the ``maxZoom``.
    @discardableResult
    public func maxZoom(_ value: Double) -> Self {
        self.maxZoom = value
        return self
    }

    /// Modifier. Sets the ``minZoom``.
    @discardableResult
    public func minZoom(_ value: Double) -> Self {
        self.minZoom = value
        return self
    }
}
