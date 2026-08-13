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

}
