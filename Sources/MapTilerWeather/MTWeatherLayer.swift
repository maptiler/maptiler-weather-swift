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

    /// Determining if map.triggerRepaint() is called when the animation is paused.
    /// Defaults to true.
    public var repaintOnPausedAnimation: Bool? = true

    /// Whether or not to use time interpolation. Defaults to true.
    public var timeInterpolation: Bool? = true

    /// Whether or not to use local smoothing. Defaults to true.
    public var localSmoothing: Bool? = true

    /// Number of smoothing bins.
    public var nbSmoothingBins: Int?

    /// Maximum smoothing distance.
    public var maxSmoothingDistance: Double?

    /// Smoothing distance decay factor.
    public var smoothingDistanceDecayFactor: Double?

    /// Whether or not to load lower zoom levels.
    public var loadLowerZoomLevels: Bool?

    /// Whether or not to render transparent area.
    public var renderTransparentArea: Bool?

    /// Whether this layer is displayed. Defaults to .visible.
    public var visibility: MTLayerVisibility? = .visible

    /// The ID of an existing layer to insert this weather layer before.
    /// If nil, the SDK will automatically attempt to place it below the first symbol (label) layer.
    public var beforeId: String?

    /// Color ramp used to represent the weather data.
    public var colorRamp: MTWeatherColorRamp?

    /// Coloring fragment used to represent the weather data.
    /// This is a more advanced way to specify coloring, including the data decoder.
    public var coloring: MTColoringFragment?

    /// Time for which to display the weather data.
    public var time: Date?

    /// Weak reference to the map view this layer is added to.
    internal weak var mapView: MTMapView?

    /// Active layers tracking for event routing
    @MainActor
    internal static var activeLayers = NSHashTable<MTWeatherLayer>.weakObjects()

    // MARK: - Events

    /// Called only once after the layer has been added to the map,
    /// when all the necessary weather data source are loaded and ready to be used.
    public var onSourceReady: (() -> Void)?

    /// Called when the animation is starting to play or plays after having been on pause
    /// after calling `.animate(...)`. Provides the timestamp in seconds.
    public var onPlayAnimation: ((Double) -> Void)?

    /// Called when the animation is being paused after calling `.animate(0)`. Provides the timestamp in seconds.
    public var onPauseAnimation: ((Double) -> Void)?

    /// Called for each animation update, possibly many times per second. Provides the timestamp in seconds.
    public var onTick: ((Double) -> Void)?

    /// Called when the progress time of the animation is manually set with
    /// `.setAnimationTime(...)`. Provides the timestamp in seconds.
    public var onAnimationTimeSet: ((Double) -> Void)?

    open var jsClassName: String {
        return "WeatherLayer"
    }

    /// Initializes the weather layer with an identifier and an optional source identifier.
    public init(identifier: String, sourceIdentifier: String = "") {
        self.identifier = identifier
        self.sourceIdentifier = sourceIdentifier
        Task { @MainActor in
            Self.activeLayers.add(self)
        }
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
        repaintOnPausedAnimation = try container.decodeIfPresent(Bool.self, forKey: .repaintOnPausedAnimation)
        timeInterpolation = try container.decodeIfPresent(Bool.self, forKey: .timeInterpolation)
        localSmoothing = try container.decodeIfPresent(Bool.self, forKey: .localSmoothing)
        nbSmoothingBins = try container.decodeIfPresent(Int.self, forKey: .nbSmoothingBins)
        maxSmoothingDistance = try container.decodeIfPresent(Double.self, forKey: .maxSmoothingDistance)
        smoothingDistanceDecayFactor = try container.decodeIfPresent(Double.self, forKey: .smoothingDistanceDecayFactor)
        loadLowerZoomLevels = try container.decodeIfPresent(Bool.self, forKey: .loadLowerZoomLevels)
        renderTransparentArea = try container.decodeIfPresent(Bool.self, forKey: .renderTransparentArea)

        colorRamp = try container.decodeIfPresent(MTWeatherColorRamp.self, forKey: .colorRamp)
        coloring = try container.decodeIfPresent(MTGradientColoringFragment.self, forKey: .coloring)

        if let visibilityRaw = try container.decodeIfPresent(String.self, forKey: .visibility) {
            visibility = MTLayerVisibility(rawValue: visibilityRaw)
        }
        Task { @MainActor in
            Self.activeLayers.add(self)
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
        try container.encodeIfPresent(repaintOnPausedAnimation, forKey: .repaintOnPausedAnimation)
        try container.encodeIfPresent(timeInterpolation, forKey: .timeInterpolation)
        try container.encodeIfPresent(localSmoothing, forKey: .localSmoothing)
        try container.encodeIfPresent(nbSmoothingBins, forKey: .nbSmoothingBins)
        try container.encodeIfPresent(maxSmoothingDistance, forKey: .maxSmoothingDistance)
        try container.encodeIfPresent(smoothingDistanceDecayFactor, forKey: .smoothingDistanceDecayFactor)
        try container.encodeIfPresent(loadLowerZoomLevels, forKey: .loadLowerZoomLevels)
        try container.encodeIfPresent(renderTransparentArea, forKey: .renderTransparentArea)

        try container.encodeIfPresent(colorRamp, forKey: .colorRamp)
        try container.encodeIfPresent(coloring, forKey: .coloring)
        try container.encodeIfPresent(visibility?.rawValue, forKey: .visibility)
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case type
        case source = "source"
        case maxZoom = "maxzoom"
        case minZoom = "minzoom"
        case sourceLayer = "source-layer"
        case opacity
        case smooth
        case repaintOnPausedAnimation
        case timeInterpolation
        case localSmoothing
        case nbSmoothingBins
        case maxSmoothingDistance
        case smoothingDistanceDecayFactor
        case loadLowerZoomLevels
        case renderTransparentArea
        case colorRamp = "colorramp"
        case coloring
        case visibility
    }
}

// MARK: - Map & Events

extension MTWeatherLayer {
    internal func handleEvent(_ event: String, data: [String: Any]?) {
        switch event {
        case "sourceReady":
            self.onSourceReady?()
        case "playAnimation":
            if let time = data?["time"] as? Double {
                self.onPlayAnimation?(time)
            }
        case "pauseAnimation":
            if let time = data?["time"] as? Double {
                self.onPauseAnimation?(time)
            }
        case "tick":
            if let time = data?["time"] as? Double {
                self.onTick?(time)
            }
        case "animationTimeSet":
            if let time = data?["time"] as? Double {
                self.onAnimationTimeSet?(time)
            }
        default:
            break
        }
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
            let command = AddWeatherLayerCommand(layer: self, beforeId: self.beforeId)
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
}

// MARK: - Animation & Methods

extension MTWeatherLayer {
    /// Changes the global opacity of the layer
    public func setOpacity(_ opacity: Double) {
        self.opacity = opacity
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "setOpacity",
                arguments: [.double(opacity)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Change the visualization to a specific time. Does not stop animation.
    public func setAnimationTime(_ time: Double) {
        self.time = Date(timeIntervalSince1970: time)
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "setAnimationTime",
                arguments: [.double(time)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Change the visualization to a specific time date. Does not stop animation.
    public func setAnimationTime(_ date: Date) {
        setAnimationTime(date.timeIntervalSince1970)
    }

    /// Changes the speed of the animation. 0 to stop.
    /// The speed is in number of real world milliseconds per animation second.
    public func animate(timePerSecond: Double) {
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "animate",
                arguments: [.double(timePerSecond)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Animate by a factor of real life speed. 0 to stop.
    public func animateByFactor(_ factor: Double) {
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "animateByFactor",
                arguments: [.double(factor)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    private func getDoubleValue(for methodName: String) async throws -> Double? {
        guard let mapView = self.mapView else { return nil }
        let command = WeatherLayerValueCommand(layerId: self.identifier, methodName: methodName)
        let result = try await mapView.execute(command: command)
        if case .double(let value) = result {
            return value
        }
        return nil
    }

    private func getDateValue(for methodName: String) async throws -> Date? {
        if let timestamp = try await getDoubleValue(for: methodName) {
            if timestamp.isInfinite || timestamp.isNaN { return nil }
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }

    /// Get the time of the first TimeFrame (always the begining of the animation) as a UNIX timestamp in seconds.
    public func getAnimationStart() async throws -> Double? {
        return try await getDoubleValue(for: "getAnimationStart")
    }

    /// Get the start date of the animated sequence
    public func getAnimationStartDate() async throws -> Date? {
        return try await getDateValue(for: "getAnimationStart")
    }

    /// Get the end time of the animation as a UNIX timestamp in seconds.
    public func getAnimationEnd() async throws -> Double? {
        return try await getDoubleValue(for: "getAnimationEnd")
    }

    /// Get the end date of the animated sequence
    public func getAnimationEndDate() async throws -> Date? {
        return try await getDateValue(for: "getAnimationEnd")
    }

    /// Get the current time of the animation as a UNIX timestamp in seconds.
    public func getAnimationTime() async throws -> Double? {
        return try await getDoubleValue(for: "getAnimationTime")
    }

    /// Get the current time of the animated sequence
    public func getAnimationTimeDate() async throws -> Date? {
        return try await getDateValue(for: "getAnimationTime")
    }

    /// Get the animation speed factor
    public func getAnimationSpeed() async throws -> Double? {
        return try await getDoubleValue(for: "getAnimationSpeed")
    }

    /// Determining if map.triggerRepaint() is called when the animation is paused.
    public func setRepaintOnPausedAnimation(_ enabled: Bool) {
        self.repaintOnPausedAnimation = enabled
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "setRepaintOnPausedAnimation",
                arguments: [.bool(enabled)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Toggles data interpolation between keyframes.
    public func setTimeInterpolation(_ enabled: Bool) {
        self.timeInterpolation = enabled
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "setTimeInterpolation",
                arguments: [.bool(enabled)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Toggles data smoothing.
    public func setLocalSmoothing(_ enabled: Bool) {
        self.localSmoothing = enabled
        guard let mapView = self.mapView else { return }
        Task {
            let command = WeatherLayerMethodCommand(
                layerId: self.identifier,
                methodName: "setLocalSmoothing",
                arguments: [.bool(enabled)]
            )
            _ = try? await mapView.execute(command: command)
        }
    }

    /// Tells whether the animation is currently playing
    public func isPlaying() async throws -> Bool? {
        guard let mapView = self.mapView else { return nil }
        let command = WeatherLayerValueCommand(layerId: self.identifier, methodName: "isPlaying")
        let result = try await mapView.execute(command: command)
        if case .bool(let value) = result {
            return value
        }
        return nil
    }
}

// MARK: - Codable extension

extension MTWeatherLayer {
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

    /// Modifier. Sets the ``repaintOnPausedAnimation``.
    @discardableResult
    public func repaintOnPausedAnimation(_ value: Bool) -> Self {
        self.repaintOnPausedAnimation = value
        return self
    }

    /// Modifier. Sets the ``timeInterpolation``.
    @discardableResult
    public func timeInterpolation(_ value: Bool) -> Self {
        self.timeInterpolation = value
        return self
    }

    /// Modifier. Sets the ``localSmoothing``.
    @discardableResult
    public func localSmoothing(_ value: Bool) -> Self {
        self.localSmoothing = value
        return self
    }

    /// Modifier. Sets the ``nbSmoothingBins``.
    @discardableResult
    public func nbSmoothingBins(_ value: Int) -> Self {
        self.nbSmoothingBins = value
        return self
    }

    /// Modifier. Sets the ``maxSmoothingDistance``.
    @discardableResult
    public func maxSmoothingDistance(_ value: Double) -> Self {
        self.maxSmoothingDistance = value
        return self
    }

    /// Modifier. Sets the ``smoothingDistanceDecayFactor``.
    @discardableResult
    public func smoothingDistanceDecayFactor(_ value: Double) -> Self {
        self.smoothingDistanceDecayFactor = value
        return self
    }

    /// Modifier. Sets the ``loadLowerZoomLevels``.
    @discardableResult
    public func loadLowerZoomLevels(_ value: Bool) -> Self {
        self.loadLowerZoomLevels = value
        return self
    }

    /// Modifier. Sets the ``renderTransparentArea``.
    @discardableResult
    public func renderTransparentArea(_ value: Bool) -> Self {
        self.renderTransparentArea = value
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

    /// Modifier. Sets the ``coloring``.
    @discardableResult
    public func coloring(_ value: MTColoringFragment) -> Self {
        self.coloring = value
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

    /// Modifier. Sets the ``beforeId``.
    @discardableResult
    public func beforeId(_ value: String) -> Self {
        self.beforeId = value
        return self
    }
}

extension Dictionary where Key == String, Value == Any {
    func getDouble(_ key: String) -> Double? {
        if let val = self[key] as? Double { return val }
        if let val = self[key] as? Int { return Double(val) }
        if let val = self[key] as? Float { return Double(val) }
        return nil
    }
}
