//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTWindLayer.swift
//  MapTilerWeather
//

import Foundation
import MapTilerSDK

/// A layer that displays atmospheric wind speed and direction.
///
/// The WindLayer shows the atmospheric wind speed in meter per second (m/s).
/// Forecast for speed and direction at an altitude of 10 m above ground.
public class MTWindLayer: MTWeatherLayer, @unchecked Sendable {
    override public var jsClassName: String {
        return "WindLayer"
    }

    /// Color of the particle. RGBA 0-255.
    public var color: MTRGBAColor? = MTRGBAColor(red: 255, green: 255, blue: 255, alpha: 192)

    /// Color of the particle when moving "fast". RGBA 0-255.
    public var fastColor: MTRGBAColor?

    /// Number of particles visible per 1000 px^2.
    public var density: Double? = 2.0

    /// How much the particles fade over time.
    public var fadeFactor: Double? = 0.1

    /// What is considered "fast" (in px/sec) for coloring purposes.
    public var fastSpeed: Double?

    /// Quantity of particles to be created. Has to be a power of 2 and at least 4.
    public var maxAmount: Int? = 128

    /// Use more pixels to make particles more smooth (especially when tilted).
    public var pixelRatio: Double?

    /// Time interval (in milliseconds) how often the particles are refreshed to avoid degradation.
    public var refreshInterval: Double? = 800

    /// Size of the particle.
    public var size: Double? = 1.5

    /// Speed factor of the particles.
    public var speed: Double? = 0.001

    /// If this is true, the particles gets slightly larger as they become faster.
    public var fastIsLarger: Bool? = false

    /// Initializes a new wind layer.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier. Defaults to "MapTiler Wind".
    ///   - colorRamp: Color ramp used to represent the weather data.
    ///     Defaults to ``MTWeatherColorRampPreset/windViridis``.
    ///   - opacity: The opacity at which the weather data will be drawn. Defaults to 1.
    ///   - smooth: Whether or not the colorramp must be smooth. Defaults to true.
    public init(
        identifier: String = "MapTiler Wind",
        colorRamp: MTWeatherColorRamp = MTWeatherColorRamp(preset: .windViridis),
        opacity: Double = 1.0,
        smooth: Bool = true
    ) {
        super.init(identifier: identifier)
        self.colorRamp = colorRamp
        self.opacity = opacity
        self.smooth = smooth
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let colorArray = try container.decodeIfPresent([Int].self, forKey: .color), colorArray.count >= 3 {
            let a = colorArray.count > 3 ? colorArray[3] : 255
            color = MTRGBAColor(red: colorArray[0], green: colorArray[1], blue: colorArray[2], alpha: a)
        } else {
            color = try container.decodeIfPresent(MTRGBAColor.self, forKey: .color)
        }

        if let fastColorArray = try container.decodeIfPresent([Int].self, forKey: .fastColor),
            fastColorArray.count >= 3 {
            let a = fastColorArray.count > 3 ? fastColorArray[3] : 255
            fastColor = MTRGBAColor(red: fastColorArray[0], green: fastColorArray[1], blue: fastColorArray[2], alpha: a)
        } else {
            fastColor = try container.decodeIfPresent(MTRGBAColor.self, forKey: .fastColor)
        }

        density = try container.decodeIfPresent(Double.self, forKey: .density)
        fadeFactor = try container.decodeIfPresent(Double.self, forKey: .fadeFactor)
        fastSpeed = try container.decodeIfPresent(Double.self, forKey: .fastSpeed)
        maxAmount = try container.decodeIfPresent(Int.self, forKey: .maxAmount)
        pixelRatio = try container.decodeIfPresent(Double.self, forKey: .pixelRatio)
        refreshInterval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
        size = try container.decodeIfPresent(Double.self, forKey: .size)
        speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        fastIsLarger = try container.decodeIfPresent(Bool.self, forKey: .fastIsLarger)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let color = color {
            try container.encode([color.red, color.green, color.blue, color.alpha ?? 255], forKey: .color)
        }
        if let fastColor = fastColor {
            try container.encode(
                [fastColor.red, fastColor.green, fastColor.blue, fastColor.alpha ?? 255],
                forKey: .fastColor
            )
        }
        try container.encodeIfPresent(density, forKey: .density)
        try container.encodeIfPresent(fadeFactor, forKey: .fadeFactor)
        try container.encodeIfPresent(fastSpeed, forKey: .fastSpeed)
        try container.encodeIfPresent(maxAmount, forKey: .maxAmount)
        try container.encodeIfPresent(pixelRatio, forKey: .pixelRatio)
        try container.encodeIfPresent(refreshInterval, forKey: .refreshInterval)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(speed, forKey: .speed)
        try container.encodeIfPresent(fastIsLarger, forKey: .fastIsLarger)
        try super.encode(to: encoder)
    }

    enum CodingKeys: String, CodingKey {
        case color
        case fastColor
        case density
        case fadeFactor
        case fastSpeed
        case maxAmount
        case pixelRatio
        case refreshInterval
        case size
        case speed
        case fastIsLarger
    }

    /// Picks wind data at a specific location.
    ///
    /// - Parameters:
    ///   - lng: Longitude.
    ///   - lat: Latitude.
    /// - Returns: Wind data value, or nil if not available.
    public func pickAt(lng: Double, lat: Double) async throws -> MTWindValue? {
        guard let dict = try await super.pickAt(lng: lng, lat: lat) else {
            return nil
        }

        return MTWindValue(dict: dict)
    }
}

/// Wind value at a given location.
public struct MTWindValue: Sendable {
    /// Conventional 16 compass direction where the wind comes from.
    public let compassDirection: String

    /// Angular direction in degrees towards which the wind is blowing (0° North, 90° East).
    public let directionAngle: Double

    /// Wind speed in feet per second (ft/s).
    public let speedFeetPerSecond: Double

    /// Wind speed in kilometer per hour (km/h).
    public let speedKilometersPerHour: Double

    /// Wind speed in knots (nautical miles per hour).
    public let speedKnots: Double

    /// Wind speed in meters per second (m/s).
    public let speedMetersPerSecond: Double

    /// Wind speed in miles per hour (mph).
    public let speedMilesPerHour: Double

    init?(dict: [String: Any]) {
        guard
            let compassDirection = dict["compassDirection"] as? String,
            let directionAngle = dict["directionAngle"] as? Double,
            let speedFeetPerSecond = dict["speedFeetPerSecond"] as? Double,
            let speedKilometersPerHour = dict["speedKilometersPerHour"] as? Double,
            let speedKnots = dict["speedKnots"] as? Double,
            let speedMetersPerSecond = dict["speedMetersPerSecond"] as? Double,
            let speedMilesPerHour = dict["speedMilesPerHour"] as? Double
        else {
            return nil
        }

        self.compassDirection = compassDirection
        self.directionAngle = directionAngle
        self.speedFeetPerSecond = speedFeetPerSecond
        self.speedKilometersPerHour = speedKilometersPerHour
        self.speedKnots = speedKnots
        self.speedMetersPerSecond = speedMetersPerSecond
        self.speedMilesPerHour = speedMilesPerHour
    }
}

// MARK: - DSL Modifiers

extension MTWindLayer {
    /// Modifier. Sets the ``color``.
    @discardableResult
    public func color(_ value: MTRGBAColor) -> Self {
        self.color = value
        return self
    }

    /// Modifier. Sets the ``fastColor``.
    @discardableResult
    public func fastColor(_ value: MTRGBAColor) -> Self {
        self.fastColor = value
        return self
    }

    /// Modifier. Sets the ``density``.
    @discardableResult
    public func density(_ value: Double) -> Self {
        self.density = value
        return self
    }

    /// Modifier. Sets the ``fadeFactor``.
    @discardableResult
    public func fadeFactor(_ value: Double) -> Self {
        self.fadeFactor = value
        return self
    }

    /// Modifier. Sets the ``fastSpeed``.
    @discardableResult
    public func fastSpeed(_ value: Double) -> Self {
        self.fastSpeed = value
        return self
    }

    /// Modifier. Sets the ``maxAmount``.
    @discardableResult
    public func maxAmount(_ value: Int) -> Self {
        self.maxAmount = value
        return self
    }

    /// Modifier. Sets the ``pixelRatio``.
    @discardableResult
    public func pixelRatio(_ value: Double) -> Self {
        self.pixelRatio = value
        return self
    }

    /// Modifier. Sets the ``refreshInterval``.
    @discardableResult
    public func refreshInterval(_ value: Double) -> Self {
        self.refreshInterval = value
        return self
    }

    /// Modifier. Sets the ``size``.
    @discardableResult
    public func size(_ value: Double) -> Self {
        self.size = value
        return self
    }

    /// Modifier. Sets the ``speed``.
    @discardableResult
    public func speed(_ value: Double) -> Self {
        self.speed = value
        return self
    }

    /// Modifier. Sets the ``fastIsLarger``.
    @discardableResult
    public func fastIsLarger(_ value: Bool) -> Self {
        self.fastIsLarger = value
        return self
    }
}
