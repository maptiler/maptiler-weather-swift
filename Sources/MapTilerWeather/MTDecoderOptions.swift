//
// Copyright (c) 2026, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTDecoderOptions.swift
//  MapTilerWeather
//

import Foundation

/// Options for decoding weather data from raster tiles.
public struct MTDecoderOptions: Sendable, Codable {
    /// The color channel(s) to read data from.
    /// Common values are "r", "g", "b", "rg", etc.
    public var channel: String

    /// The real-world value that corresponds to a pixel value of 0.
    public var min: Double

    /// The real-world value that corresponds to a pixel value of 255.
    public var max: Double

    public init(channel: String, min: Double, max: Double) {
        self.channel = channel
        self.min = min
        self.max = max
    }
}
