import XCTest
@testable import MapTilerWeather

final class MapTilerWeatherTests: XCTestCase {
    func testInitialization() throws {
        let weather = MapTilerWeather()
        XCTAssertEqual(weather.version(), "1.0.0")
    }

    func testPressureLayerInitialization() throws {
        let layer = MTPressureLayer()
        XCTAssertEqual(layer.identifier, "MapTiler Pressure")
        XCTAssertEqual(layer.opacity, 1.0)
        XCTAssertEqual(layer.smooth, true)
        XCTAssertEqual(layer.jsClassName, "PressureLayer")
    }

    func testRadarLayerInitialization() throws {
        let layer = MTRadarLayer()
        XCTAssertEqual(layer.identifier, "MapTiler Radar")
        XCTAssertEqual(layer.opacity, 1.0)
        XCTAssertEqual(layer.smooth, true)
        XCTAssertEqual(layer.jsClassName, "RadarLayer")
    }

    func testTemperatureLayerInitialization() throws {
        let layer = MTTemperatureLayer()
        XCTAssertEqual(layer.identifier, "MapTiler Temperature")
        XCTAssertEqual(layer.opacity, 1.0)
        XCTAssertEqual(layer.smooth, true)
        XCTAssertEqual(layer.jsClassName, "TemperatureLayer")
    }

    func testWindLayerInitialization() throws {
        let layer = MTWindLayer()
        XCTAssertEqual(layer.identifier, "MapTiler Wind")
        XCTAssertEqual(layer.opacity, 1.0)
        XCTAssertEqual(layer.smooth, true)
        XCTAssertEqual(layer.jsClassName, "WindLayer")
        XCTAssertEqual(layer.density, 2.0)
        XCTAssertEqual(layer.size, 1.5)
        
        let color = layer.color
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.red, 255)
        XCTAssertEqual(color?.green, 255)
        XCTAssertEqual(color?.blue, 255)
        XCTAssertEqual(color?.alpha, 192)
    }

}
