import XCTest
@testable import MapTilerWeather

final class MapTilerWeatherTests: XCTestCase {
    func testInitialization() throws {
        let weather = MapTilerWeather()
        XCTAssertEqual(weather.version(), "1.0.0")
    }
}
