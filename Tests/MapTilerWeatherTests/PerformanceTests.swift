import XCTest
@testable import MapTilerWeather
import MapTilerSDK

final class PerformanceTests: XCTestCase {

    /// Measures the cost of encoding a complex Wind Layer to JSON.
    /// This happens every time a layer is added to the map.
    func testWindLayerEncodingPerformance() {
        let layer = MTWindLayer(
            identifier: "Performance Wind",
            colorRamp: MTWeatherColorRamp(preset: .windViridis),
            opacity: 0.8,
            smooth: true
        )
        layer.density = 5.0
        layer.size = 2.0
        
        let encoder = JSONEncoder()
        
        measure {
            for _ in 0..<100 {
                _ = try? encoder.encode(layer)
            }
        }
    }

    /// Measures the cost of generating the JavaScript command for adding a layer.
    /// This includes JSON encoding and string concatenation.
    func testAddLayerCommandGenerationPerformance() {
        let layer = MTTemperatureLayer(
            identifier: "Performance Temp",
            colorRamp: MTWeatherColorRamp(preset: .temperature3),
            opacity: 1.0,
            smooth: true
        )
        
        let command = AddWeatherLayerCommand(layer: layer, beforeId: "labels")
        
        measure {
            for _ in 0..<100 {
                _ = command.toJS()
            }
        }
    }

    /// Measures the cost of calculating colors from a color ramp.
    /// Useful if we ever do CPU-side processing of weather data.
    func testColorRampLookupPerformance() {
        let ramp = MTWeatherColorRamp(preset: .temperature3)
        
        measure {
            for i in 0..<1000 {
                let value = Double(i % 100) - 20.0 // -20 to 80 range
                _ = ramp.getColor(at: value, smooth: true)
            }
        }
    }
}
