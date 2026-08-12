import Foundation
import MapTilerSDK
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Implementation of Color Ramp for MapTiler Weather SDK.
public final class MTWeatherColorRamp: @unchecked Sendable, Codable {
    public private(set) var min: Double
    public private(set) var max: Double
    public private(set) var stops: [MTColorRampStop]

    enum CodingKeys: String, CodingKey {
        case min
        case max
        case stops
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        min = try container.decode(Double.self, forKey: .min)
        max = try container.decode(Double.self, forKey: .max)
        stops = try container.decode([MTColorRampStop].self, forKey: .stops)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(min, forKey: .min)
        try container.encode(max, forKey: .max)
        try container.encode(stops, forKey: .stops)
    }

    /// Initializes a custom weather color ramp with explicit stops.
    public init(min: Double? = nil, max: Double? = nil, stops: [MTColorRampStop]) {
        let sortedStops = stops.sorted { $0.value < $1.value }
        self.stops = sortedStops
        self.min = min ?? sortedStops.first?.value ?? 0
        self.max = max ?? sortedStops.last?.value ?? 1
    }

    /// Initializes a color ramp from a meteorological preset.
    public convenience init(preset: MTWeatherColorRampPreset) {
        self.init(stops: preset.stops)
    }

    /// Converts this weather color ramp into a standard `MTColorRamp` suitable for map layers.
    @MainActor
    public var coreRamp: MTColorRamp {
        return MTColorRamp(min: min, max: max, stops: stops)
    }

    /// Returns bounds of the color ramp.
    public var bounds: MTColorRampBounds {
        let json = "{\"min\":\(min),\"max\":\(max)}"

        guard let data = json.data(using: .utf8) else {
            fatalError("Invalid JSON string for MTColorRampBounds")
        }

        do {
            return try JSONDecoder().decode(MTColorRampBounds.self, from: data)
        } catch {
            fatalError("Failed to decode MTColorRampBounds: \(error)")
        }
    }

    /// Clones the color ramp.
    public func clone() -> MTWeatherColorRamp {
        return MTWeatherColorRamp(min: min, max: max, stops: stops)
    }

    /// Returns a ramp reversed in-place or cloned depending on the `clone` flag.
    @discardableResult
    public func reverse(clone: Bool = true) -> MTWeatherColorRamp {
        let target = clone ? self.clone() : self

        let count = target.stops.count
        for i in 0..<(count / 2) {
            let oppositeIndex = count - 1 - i
            let tempColor = target.stops[i].color

            // Keep the value the same, just swap the colors
            target.stops[i].color = target.stops[oppositeIndex].color
            target.stops[oppositeIndex].color = tempColor
        }
        return target
    }

    /// Scales the ramp to the given bounds.
    @discardableResult
    public func scale(min newMin: Double, max newMax: Double, clone: Bool = true) -> MTWeatherColorRamp {
        let target = clone ? self.clone() : self
        guard let first = target.stops.first, let last = target.stops.last else { return target }

        let currentMin = first.value
        let currentMax = last.value
        let currentSpan = currentMax - currentMin
        let newSpan = newMax - newMin

        for i in 0..<target.stops.count {
            let currentValue = target.stops[i].value
            let normalizedValue = currentSpan == 0 ? 0 : (currentValue - currentMin) / currentSpan
            let newValue = normalizedValue * newSpan + newMin
            target.stops[i].value = newValue
        }

        target.min = newMin
        target.max = newMax

        return target
    }

    /// Replaces the stops on the ramp.
    @discardableResult
    public func setStops(_ stops: [MTColorRampStop], clone: Bool = true) -> MTWeatherColorRamp {
        let target = clone ? self.clone() : self
        let sortedStops = stops.sorted { $0.value < $1.value }
        target.stops = sortedStops
        target.min = sortedStops.first?.value ?? 0
        target.max = sortedStops.last?.value ?? 1
        return target
    }

    /// Returns the color at the provided value.
    public func getColor(at value: Double, smooth: Bool = true) -> MTRGBAColor {
        guard !stops.isEmpty else { return MTRGBAColor(red: 0, green: 0, blue: 0, alpha: 255) }

        if value <= stops.first!.value {
            return stops.first!.color
        }

        if value >= stops.last!.value {
            return stops.last!.color
        }

        for i in 0..<(stops.count - 1) {
            if value > stops[i + 1].value {
                continue
            }

            let colorBefore = stops[i].color
            if !smooth {
                return colorBefore
            }

            let valueBefore = stops[i].value
            let valueAfter = stops[i + 1].value
            let colorAfter = stops[i + 1].color

            let beforeRatio = (valueAfter - value) / (valueAfter - valueBefore)
            let afterRatio = 1.0 - beforeRatio

            let redVal = Int(round(Double(colorBefore.red) * beforeRatio + Double(colorAfter.red) * afterRatio))
            let greenVal = Int(round(Double(colorBefore.green) * beforeRatio + Double(colorAfter.green) * afterRatio))
            let blueVal = Int(round(Double(colorBefore.blue) * beforeRatio + Double(colorAfter.blue) * afterRatio))

            let alphaBefore = Double(colorBefore.alpha ?? 255)
            let alphaAfter = Double(colorAfter.alpha ?? 255)
            let alphaVal = Int(round(alphaBefore * beforeRatio + alphaAfter * afterRatio))

            return MTRGBAColor(
                red: redVal,
                green: greenVal,
                blue: blueVal,
                alpha: alphaVal
            )
        }

        return MTRGBAColor(red: 0, green: 0, blue: 0, alpha: 255)
    }

    /// Prepends a transparent stop at the beginning of the ramp.
    @discardableResult
    public func transparentStart(clone: Bool = true) -> MTWeatherColorRamp {
        let target = clone ? self.clone() : self
        guard let first = target.stops.first else { return target }

        let newFirst = MTColorRampStop(
            value: first.value,
            color: MTRGBAColor(red: first.color.red, green: first.color.green, blue: first.color.blue, alpha: 0)
        )

        target.stops.insert(newFirst, at: 0)

        // Push the original first stop slightly up
        if target.stops.count > 1 {
            target.stops[1].value += 0.001
        }

        return target
    }

    /// Returns true if the first stop is transparent.
    public var hasTransparentStart: Bool {
        guard let first = stops.first else { return false }
        return first.color.alpha == 0
    }

#if canImport(UIKit)
    /// Renders the ramp to a canvas strip and returns it as `UIImage`.
    public func getCanvasStrip(size: Int = 512, horizontal: Bool = true, smooth: Bool = true) -> UIImage? {
        guard !stops.isEmpty else { return nil }

        let width = horizontal ? size : 1
        let height = horizontal ? 1 : size
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        let startValue = stops.first!.value
        let endValue = stops.last!.value
        let valueSpan = endValue - startValue
        let valueStep = valueSpan / Double(size)

        for i in 0..<size {
            let color = getColor(at: startValue + Double(i) * valueStep, smooth: smooth)
            let uiColor = UIColor(
                red: CGFloat(color.red) / 255.0,
                green: CGFloat(color.green) / 255.0,
                blue: CGFloat(color.blue) / 255.0,
                alpha: CGFloat(color.alpha ?? 255) / 255.0
            )
            context.setFillColor(uiColor.cgColor)

            let pixelRect = horizontal
                ? CGRect(x: i, y: 0, width: 1, height: 1)
                : CGRect(x: 0, y: i, width: 1, height: 1)
            context.fill(pixelRect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
#elseif canImport(AppKit)
    /// Renders the ramp to a canvas strip and returns it as `NSImage`.
    public func getCanvasStrip(size: Int = 512, horizontal: Bool = true, smooth: Bool = true) -> NSImage? {
        guard !stops.isEmpty else { return nil }

        let width = horizontal ? size : 1
        let height = horizontal ? 1 : size
        let rect = NSRect(x: 0, y: 0, width: width, height: height)

        let image = NSImage(size: rect.size)
        image.lockFocus()

        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return nil
        }

        let startValue = stops.first!.value
        let endValue = stops.last!.value
        let valueSpan = endValue - startValue
        let valueStep = valueSpan / Double(size)

        for i in 0..<size {
            let color = getColor(at: startValue + Double(i) * valueStep, smooth: smooth)
            let nsColor = NSColor(
                red: CGFloat(color.red) / 255.0,
                green: CGFloat(color.green) / 255.0,
                blue: CGFloat(color.blue) / 255.0,
                alpha: CGFloat(color.alpha) / 255.0
            )
            context.setFillColor(nsColor.cgColor)

            let pixelRect = horizontal ?
                NSRect(x: i, y: 0, width: 1, height: 1) :
                NSRect(x: 0, y: i, width: 1, height: 1)
            context.fill(pixelRect)
        }

        image.unlockFocus()
        return image
    }
#endif
}
