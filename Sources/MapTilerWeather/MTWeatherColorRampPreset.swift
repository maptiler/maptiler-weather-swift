import Foundation
import MapTilerSDK

/// Meteorological color ramp presets
public enum MTWeatherColorRampPreset: String, Sendable, Codable, CaseIterable {
    case makoPrecipitation = "MAKO_PRECIPITATION"
    case precipitation = "PRECIPITATION"
    case precipitation2 = "PRECIPITATION_2"
    case pressure = "PRESSURE"
    case pressure2 = "PRESSURE_2"
    case pressure3 = "PRESSURE_3"
    case pressure4 = "PRESSURE_4"
    case pressureCividis = "PRESSURE_CIVIDIS"
    case radar = "RADAR"
    case radarCloud = "RADAR_CLOUD"
    case radarRocket = "RADAR_ROCKET"
    case temperature2 = "TEMPERATURE_2"
    case temperature3 = "TEMPERATURE_3"
    case temperatureTurbo = "TEMPERATURE_TURBO"
    case terrain = "TERRAIN"
    case windViridis = "WIND_VIRIDIS"
    case windRocket = "WIND_ROCKET"
}

extension MTWeatherColorRampPreset {
    /// Returns the raw color stops for the given meteorological preset.
    public var stops: [MTColorRampStop] {
        switch self {
        case .makoPrecipitation:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 255, green: 255, blue: 255, alpha: 0)),
                MTColorRampStop(value: 0.1, color: MTRGBAColor(red: 222, green: 245, blue: 229, alpha: 255)),
                MTColorRampStop(value: 1, color: MTRGBAColor(red: 168, green: 225, blue: 188, alpha: 255)),
                MTColorRampStop(value: 2, color: MTRGBAColor(red: 96, green: 206, blue: 172, alpha: 255)),
                MTColorRampStop(value: 4, color: MTRGBAColor(red: 61, green: 180, blue: 173, alpha: 255)),
                MTColorRampStop(value: 6, color: MTRGBAColor(red: 52, green: 151, blue: 169, alpha: 255)),
                MTColorRampStop(value: 8, color: MTRGBAColor(red: 53, green: 123, blue: 162, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 57, green: 93, blue: 156, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 65, green: 64, blue: 129, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 56, green: 42, blue: 84, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 38, green: 23, blue: 42, alpha: 255)),
                MTColorRampStop(value: 50, color: MTRGBAColor(red: 11, green: 4, blue: 5, alpha: 255))
            ]
        case .precipitation:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 111, green: 111, blue: 111, alpha: 0)),
                MTColorRampStop(value: 0.6, color: MTRGBAColor(red: 60, green: 116, blue: 160, alpha: 180)),
                MTColorRampStop(value: 6, color: MTRGBAColor(red: 59, green: 161, blue: 161, alpha: 255)),
                MTColorRampStop(value: 8, color: MTRGBAColor(red: 59, green: 161, blue: 61, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 130, green: 161, blue: 59, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 161, green: 161, blue: 59, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 161, green: 59, blue: 59, alpha: 255)),
                MTColorRampStop(value: 31, color: MTRGBAColor(red: 161, green: 59, blue: 161, alpha: 255)),
                MTColorRampStop(value: 50, color: MTRGBAColor(red: 168, green: 168, blue: 168, alpha: 255))
            ]
        case .precipitation2:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 255, green: 255, blue: 255, alpha: 0)),
                MTColorRampStop(value: 0.1, color: MTRGBAColor(red: 171, green: 218, blue: 252, alpha: 255)),
                MTColorRampStop(value: 1, color: MTRGBAColor(red: 98, green: 186, blue: 249, alpha: 255)),
                MTColorRampStop(value: 2, color: MTRGBAColor(red: 87, green: 160, blue: 240, alpha: 255)),
                MTColorRampStop(value: 4, color: MTRGBAColor(red: 112, green: 128, blue: 250, alpha: 255)),
                MTColorRampStop(value: 6, color: MTRGBAColor(red: 128, green: 102, blue: 245, alpha: 255)),
                MTColorRampStop(value: 8, color: MTRGBAColor(red: 152, green: 102, blue: 245, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 154, green: 87, blue: 172, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 228, green: 88, blue: 126, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 247, green: 135, blue: 95, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 249, green: 206, blue: 64, alpha: 255)),
                MTColorRampStop(value: 50, color: MTRGBAColor(red: 250, green: 248, blue: 168, alpha: 52))
            ]
        case .pressure:
            return [
                MTColorRampStop(value: 900, color: MTRGBAColor(red: 0, green: 0, blue: 100, alpha: 250)),
                MTColorRampStop(value: 950, color: MTRGBAColor(red: 0, green: 0, blue: 255, alpha: 250)),
                MTColorRampStop(value: 980, color: MTRGBAColor(red: 0, green: 0, blue: 255, alpha: 120)),
                MTColorRampStop(value: 1000, color: MTRGBAColor(red: 255, green: 255, blue: 255, alpha: 0)),
                MTColorRampStop(value: 1020, color: MTRGBAColor(red: 255, green: 0, blue: 0, alpha: 120)),
                MTColorRampStop(value: 1080, color: MTRGBAColor(red: 255, green: 0, blue: 0, alpha: 250))
            ]
        case .pressure2:
            return [
                MTColorRampStop(value: 900, color: MTRGBAColor(red: 8, green: 16, blue: 48, alpha: 255)),
                MTColorRampStop(value: 950, color: MTRGBAColor(red: 0, green: 32, blue: 96, alpha: 255)),
                MTColorRampStop(value: 976, color: MTRGBAColor(red: 0, green: 52, blue: 146, alpha: 255)),
                MTColorRampStop(value: 986, color: MTRGBAColor(red: 0, green: 90, blue: 148, alpha: 255)),
                MTColorRampStop(value: 995, color: MTRGBAColor(red: 0, green: 117, blue: 146, alpha: 255)),
                MTColorRampStop(value: 1002, color: MTRGBAColor(red: 26, green: 140, blue: 147, alpha: 255)),
                MTColorRampStop(value: 1007, color: MTRGBAColor(red: 103, green: 162, blue: 155, alpha: 255)),
                MTColorRampStop(value: 1011, color: MTRGBAColor(red: 155, green: 183, blue: 172, alpha: 255)),
                MTColorRampStop(value: 1013, color: MTRGBAColor(red: 182, green: 182, blue: 182, alpha: 255)),
                MTColorRampStop(value: 1015, color: MTRGBAColor(red: 176, green: 174, blue: 152, alpha: 255)),
                MTColorRampStop(value: 1019, color: MTRGBAColor(red: 167, green: 147, blue: 107, alpha: 255)),
                MTColorRampStop(value: 1024, color: MTRGBAColor(red: 163, green: 116, blue: 67, alpha: 255)),
                MTColorRampStop(value: 1030, color: MTRGBAColor(red: 159, green: 81, blue: 44, alpha: 255)),
                MTColorRampStop(value: 1038, color: MTRGBAColor(red: 142, green: 47, blue: 57, alpha: 255)),
                MTColorRampStop(value: 1046, color: MTRGBAColor(red: 111, green: 24, blue: 64, alpha: 255)),
                MTColorRampStop(value: 1080, color: MTRGBAColor(red: 48, green: 8, blue: 24, alpha: 255))
            ]
        case .pressure3:
            return [
                MTColorRampStop(value: 900, color: MTRGBAColor(red: 40, green: 46, blue: 117, alpha: 255)),
                MTColorRampStop(value: 950, color: MTRGBAColor(red: 40, green: 51, blue: 121, alpha: 255)),
                MTColorRampStop(value: 976, color: MTRGBAColor(red: 42, green: 63, blue: 125, alpha: 255)),
                MTColorRampStop(value: 986, color: MTRGBAColor(red: 55, green: 97, blue: 141, alpha: 255)),
                MTColorRampStop(value: 995, color: MTRGBAColor(red: 69, green: 115, blue: 150, alpha: 255)),
                MTColorRampStop(value: 1002, color: MTRGBAColor(red: 87, green: 144, blue: 168, alpha: 255)),
                MTColorRampStop(value: 1007, color: MTRGBAColor(red: 125, green: 184, blue: 194, alpha: 255)),
                MTColorRampStop(value: 1011, color: MTRGBAColor(red: 195, green: 226, blue: 226, alpha: 255)),
                MTColorRampStop(value: 1013, color: MTRGBAColor(red: 245, green: 220, blue: 196, alpha: 255)),
                MTColorRampStop(value: 1015, color: MTRGBAColor(red: 232, green: 191, blue: 160, alpha: 255)),
                MTColorRampStop(value: 1019, color: MTRGBAColor(red: 219, green: 154, blue: 125, alpha: 255)),
                MTColorRampStop(value: 1024, color: MTRGBAColor(red: 210, green: 115, blue: 98, alpha: 255)),
                MTColorRampStop(value: 1030, color: MTRGBAColor(red: 194, green: 72, blue: 67, alpha: 255)),
                MTColorRampStop(value: 1038, color: MTRGBAColor(red: 199, green: 61, blue: 60, alpha: 255)),
                MTColorRampStop(value: 1046, color: MTRGBAColor(red: 177, green: 50, blue: 54, alpha: 255)),
                MTColorRampStop(value: 1080, color: MTRGBAColor(red: 159, green: 42, blue: 48, alpha: 255))
            ]
        case .pressure4:
            return [
                MTColorRampStop(value: 900, color: MTRGBAColor(red: 40, green: 46, blue: 117, alpha: 255)),
                MTColorRampStop(value: 950, color: MTRGBAColor(red: 40, green: 51, blue: 121, alpha: 255)),
                MTColorRampStop(value: 976, color: MTRGBAColor(red: 42, green: 63, blue: 125, alpha: 255)),
                MTColorRampStop(value: 986, color: MTRGBAColor(red: 55, green: 97, blue: 141, alpha: 255)),
                MTColorRampStop(value: 995, color: MTRGBAColor(red: 69, green: 115, blue: 150, alpha: 255)),
                MTColorRampStop(value: 1002, color: MTRGBAColor(red: 87, green: 144, blue: 168, alpha: 255)),
                MTColorRampStop(value: 1007, color: MTRGBAColor(red: 125, green: 184, blue: 194, alpha: 255)),
                MTColorRampStop(value: 1012.5, color: MTRGBAColor(red: 226, green: 226, blue: 226, alpha: 255)),
                MTColorRampStop(value: 1013.5, color: MTRGBAColor(red: 226, green: 226, blue: 226, alpha: 255)),
                MTColorRampStop(value: 1015, color: MTRGBAColor(red: 232, green: 191, blue: 160, alpha: 255)),
                MTColorRampStop(value: 1019, color: MTRGBAColor(red: 219, green: 154, blue: 125, alpha: 255)),
                MTColorRampStop(value: 1024, color: MTRGBAColor(red: 210, green: 115, blue: 98, alpha: 255)),
                MTColorRampStop(value: 1030, color: MTRGBAColor(red: 194, green: 72, blue: 67, alpha: 255)),
                MTColorRampStop(value: 1038, color: MTRGBAColor(red: 199, green: 61, blue: 60, alpha: 255)),
                MTColorRampStop(value: 1046, color: MTRGBAColor(red: 177, green: 50, blue: 54, alpha: 255)),
                MTColorRampStop(value: 1080, color: MTRGBAColor(red: 159, green: 42, blue: 48, alpha: 255))
            ]
        case .pressureCividis:
            return [
                MTColorRampStop(value: 900, color: MTRGBAColor(red: 0, green: 32, blue: 77, alpha: 255)),
                MTColorRampStop(value: 950, color: MTRGBAColor(red: 0, green: 37, blue: 82, alpha: 255)),
                MTColorRampStop(value: 976, color: MTRGBAColor(red: 15, green: 56, blue: 110, alpha: 255)),
                MTColorRampStop(value: 986, color: MTRGBAColor(red: 49, green: 68, blue: 107, alpha: 255)),
                MTColorRampStop(value: 995, color: MTRGBAColor(red: 70, green: 80, blue: 107, alpha: 255)),
                MTColorRampStop(value: 1002, color: MTRGBAColor(red: 87, green: 92, blue: 109, alpha: 255)),
                MTColorRampStop(value: 1007, color: MTRGBAColor(red: 102, green: 105, blue: 112, alpha: 255)),
                MTColorRampStop(value: 1011, color: MTRGBAColor(red: 117, green: 117, blue: 117, alpha: 255)),
                MTColorRampStop(value: 1013, color: MTRGBAColor(red: 132, green: 130, blue: 121, alpha: 255)),
                MTColorRampStop(value: 1015, color: MTRGBAColor(red: 149, green: 143, blue: 120, alpha: 255)),
                MTColorRampStop(value: 1019, color: MTRGBAColor(red: 166, green: 157, blue: 117, alpha: 255)),
                MTColorRampStop(value: 1024, color: MTRGBAColor(red: 184, green: 171, blue: 112, alpha: 255)),
                MTColorRampStop(value: 1030, color: MTRGBAColor(red: 203, green: 186, blue: 105, alpha: 255)),
                MTColorRampStop(value: 1038, color: MTRGBAColor(red: 221, green: 201, blue: 95, alpha: 255)),
                MTColorRampStop(value: 1046, color: MTRGBAColor(red: 250, green: 229, blue: 65, alpha: 255)),
                MTColorRampStop(value: 1080, color: MTRGBAColor(red: 255, green: 234, blue: 70, alpha: 255))
            ]
        case .radar:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 7, green: 235, blue: 236, alpha: 0)),
                MTColorRampStop(value: 4, color: MTRGBAColor(red: 7, green: 235, blue: 236, alpha: 80)),
                MTColorRampStop(value: 5, color: MTRGBAColor(red: 7, green: 235, blue: 236, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 0, green: 159, blue: 246, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 0, green: 0, blue: 247, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 3, green: 255, blue: 0, alpha: 255)),
                MTColorRampStop(value: 25, color: MTRGBAColor(red: 0, green: 200, blue: 2, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 1, green: 144, blue: 0, alpha: 255)),
                MTColorRampStop(value: 35, color: MTRGBAColor(red: 255, green: 255, blue: 0, alpha: 255)),
                MTColorRampStop(value: 40, color: MTRGBAColor(red: 231, green: 192, blue: 0, alpha: 255)),
                MTColorRampStop(value: 45, color: MTRGBAColor(red: 255, green: 145, blue: 3, alpha: 255)),
                MTColorRampStop(value: 50, color: MTRGBAColor(red: 255, green: 0, blue: 0, alpha: 255)),
                MTColorRampStop(value: 55, color: MTRGBAColor(red: 215, green: 0, blue: 0, alpha: 255)),
                MTColorRampStop(value: 60, color: MTRGBAColor(red: 192, green: 0, blue: 0, alpha: 255)),
                MTColorRampStop(value: 65, color: MTRGBAColor(red: 255, green: 0, blue: 255, alpha: 255)),
                MTColorRampStop(value: 70, color: MTRGBAColor(red: 155, green: 85, blue: 200, alpha: 255)),
                MTColorRampStop(value: 75, color: MTRGBAColor(red: 235, green: 235, blue: 235, alpha: 255))
            ]
        case .radarCloud:
            return [
                MTColorRampStop(value: 4, color: MTRGBAColor(red: 134, green: 134, blue: 176, alpha: 0)),
                MTColorRampStop(value: 7, color: MTRGBAColor(red: 134, green: 134, blue: 176, alpha: 30)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 134, green: 134, blue: 176, alpha: 60)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 110, green: 110, blue: 145, alpha: 80)),
                MTColorRampStop(value: 35, color: MTRGBAColor(red: 77, green: 77, blue: 105, alpha: 140)),
                MTColorRampStop(value: 45, color: MTRGBAColor(red: 58, green: 58, blue: 87, alpha: 180)),
                MTColorRampStop(value: 60, color: MTRGBAColor(red: 26, green: 26, blue: 51, alpha: 220))
            ]
        case .radarRocket:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 250, green: 235, blue: 221, alpha: 0)),
                MTColorRampStop(value: 0.1, color: MTRGBAColor(red: 250, green: 235, blue: 221, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 246, green: 180, blue: 142, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 243, green: 118, blue: 81, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 225, green: 51, blue: 66, alpha: 255)),
                MTColorRampStop(value: 40, color: MTRGBAColor(red: 174, green: 23, blue: 89, alpha: 255)),
                MTColorRampStop(value: 50, color: MTRGBAColor(red: 112, green: 31, blue: 87, alpha: 255)),
                MTColorRampStop(value: 60, color: MTRGBAColor(red: 54, green: 25, blue: 62, alpha: 255)),
                MTColorRampStop(value: 75, color: MTRGBAColor(red: 3, green: 5, blue: 26, alpha: 255))
            ]
        case .temperature2:
            return [
                MTColorRampStop(value: -70.15, color: MTRGBAColor(red: 115, green: 70, blue: 105, alpha: 255)),
                MTColorRampStop(value: -55.15, color: MTRGBAColor(red: 202, green: 172, blue: 195, alpha: 255)),
                MTColorRampStop(value: -40.15, color: MTRGBAColor(red: 162, green: 70, blue: 145, alpha: 255)),
                MTColorRampStop(value: -25.15, color: MTRGBAColor(red: 143, green: 89, blue: 169, alpha: 255)),
                MTColorRampStop(value: -15.15, color: MTRGBAColor(red: 157, green: 219, blue: 217, alpha: 255)),
                MTColorRampStop(value: -8.15, color: MTRGBAColor(red: 106, green: 191, blue: 181, alpha: 255)),
                MTColorRampStop(value: -4.15, color: MTRGBAColor(red: 100, green: 166, blue: 189, alpha: 255)),
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 93, green: 133, blue: 198, alpha: 255)),
                MTColorRampStop(value: 0.85, color: MTRGBAColor(red: 68, green: 125, blue: 99, alpha: 255)),
                MTColorRampStop(value: 9.85, color: MTRGBAColor(red: 128, green: 147, blue: 24, alpha: 255)),
                MTColorRampStop(value: 20.85, color: MTRGBAColor(red: 243, green: 183, blue: 4, alpha: 255)),
                MTColorRampStop(value: 29.85, color: MTRGBAColor(red: 232, green: 83, blue: 25, alpha: 255)),
                MTColorRampStop(value: 46.85, color: MTRGBAColor(red: 71, green: 14, blue: 0, alpha: 255))
            ]
        case .temperature3:
            return [
                MTColorRampStop(value: -65, color: MTRGBAColor(red: 3, green: 78, blue: 77, alpha: 255)),
                MTColorRampStop(value: -55, color: MTRGBAColor(red: 4, green: 98, blue: 96, alpha: 255)),
                MTColorRampStop(value: -40, color: MTRGBAColor(red: 5, green: 122, blue: 120, alpha: 255)),
                MTColorRampStop(value: -30, color: MTRGBAColor(red: 6, green: 152, blue: 149, alpha: 255)),
                MTColorRampStop(value: -20, color: MTRGBAColor(red: 8, green: 201, blue: 198, alpha: 255)),
                MTColorRampStop(value: -15, color: MTRGBAColor(red: 20, green: 245, blue: 241, alpha: 255)),
                MTColorRampStop(value: -10, color: MTRGBAColor(red: 108, green: 237, blue: 249, alpha: 255)),
                MTColorRampStop(value: -5, color: MTRGBAColor(red: 133, green: 205, blue: 250, alpha: 255)),
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 186, green: 227, blue: 252, alpha: 255)),
                MTColorRampStop(value: 5, color: MTRGBAColor(red: 238, green: 221, blue: 145, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 232, green: 183, blue: 105, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 232, green: 137, blue: 69, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 231, green: 107, blue: 24, alpha: 255)),
                MTColorRampStop(value: 25, color: MTRGBAColor(red: 236, green: 84, blue: 19, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 236, green: 44, blue: 19, alpha: 255)),
                MTColorRampStop(value: 40, color: MTRGBAColor(red: 123, green: 23, blue: 10, alpha: 255)),
                MTColorRampStop(value: 55, color: MTRGBAColor(red: 91, green: 11, blue: 0, alpha: 255))
            ]
        case .temperatureTurbo:
            return [
                MTColorRampStop(value: -65, color: MTRGBAColor(red: 48, green: 18, blue: 59, alpha: 255)),
                MTColorRampStop(value: -55, color: MTRGBAColor(red: 64, green: 64, blue: 162, alpha: 255)),
                MTColorRampStop(value: -40, color: MTRGBAColor(red: 70, green: 107, blue: 227, alpha: 255)),
                MTColorRampStop(value: -30, color: MTRGBAColor(red: 66, green: 147, blue: 255, alpha: 255)),
                MTColorRampStop(value: -20, color: MTRGBAColor(red: 40, green: 187, blue: 236, alpha: 255)),
                MTColorRampStop(value: -15, color: MTRGBAColor(red: 24, green: 220, blue: 195, alpha: 255)),
                MTColorRampStop(value: -10, color: MTRGBAColor(red: 49, green: 242, blue: 153, alpha: 255)),
                MTColorRampStop(value: -5, color: MTRGBAColor(red: 107, green: 254, blue: 100, alpha: 255)),
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 162, green: 252, blue: 60, alpha: 255)),
                MTColorRampStop(value: 5, color: MTRGBAColor(red: 204, green: 237, blue: 52, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 237, green: 208, blue: 58, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 253, green: 173, blue: 53, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 231, green: 107, blue: 24, alpha: 255)),
                MTColorRampStop(value: 25, color: MTRGBAColor(red: 236, green: 82, blue: 15, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 210, green: 49, blue: 5, alpha: 255)),
                MTColorRampStop(value: 40, color: MTRGBAColor(red: 172, green: 23, blue: 1, alpha: 255)),
                MTColorRampStop(value: 55, color: MTRGBAColor(red: 122, green: 4, blue: 3, alpha: 255))
            ]
        case .terrain:
            return [
                MTColorRampStop(value: -10001, color: MTRGBAColor(red: 0, green: 20, blue: 60, alpha: 255)),
                MTColorRampStop(value: -5000, color: MTRGBAColor(red: 0, green: 10, blue: 30, alpha: 255)),
                MTColorRampStop(value: -1000, color: MTRGBAColor(red: 0, green: 30, blue: 80, alpha: 255)),
                MTColorRampStop(value: -100, color: MTRGBAColor(red: 0, green: 38, blue: 115, alpha: 255)),
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 122, green: 200, blue: 255, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 51, green: 102, blue: 0, alpha: 255)),
                MTColorRampStop(value: 500, color: MTRGBAColor(red: 129, green: 195, blue: 31, alpha: 255)),
                MTColorRampStop(value: 800, color: MTRGBAColor(red: 255, green: 255, blue: 204, alpha: 255)),
                MTColorRampStop(value: 1200, color: MTRGBAColor(red: 244, green: 189, blue: 69, alpha: 255)),
                MTColorRampStop(value: 2000, color: MTRGBAColor(red: 132, green: 75, blue: 0, alpha: 255)),
                MTColorRampStop(value: 3000, color: MTRGBAColor(red: 102, green: 51, blue: 12, alpha: 255)),
                MTColorRampStop(value: 8000, color: MTRGBAColor(red: 255, green: 255, blue: 255, alpha: 255))
            ]
        case .windViridis:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 68, green: 1, blue: 84, alpha: 255)),
                MTColorRampStop(value: 5, color: MTRGBAColor(red: 59, green: 82, blue: 139, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 33, green: 144, blue: 141, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 93, green: 201, blue: 99, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 253, green: 231, blue: 37, alpha: 255))
            ]
        case .windRocket:
            return [
                MTColorRampStop(value: 0, color: MTRGBAColor(red: 250, green: 235, blue: 221, alpha: 0)),
                MTColorRampStop(value: 1, color: MTRGBAColor(red: 246, green: 187, blue: 151, alpha: 255)),
                MTColorRampStop(value: 3, color: MTRGBAColor(red: 244, green: 135, blue: 94, alpha: 255)),
                MTColorRampStop(value: 5, color: MTRGBAColor(red: 236, green: 75, blue: 62, alpha: 255)),
                MTColorRampStop(value: 10, color: MTRGBAColor(red: 203, green: 27, blue: 79, alpha: 255)),
                MTColorRampStop(value: 15, color: MTRGBAColor(red: 150, green: 28, blue: 91, alpha: 255)),
                MTColorRampStop(value: 20, color: MTRGBAColor(red: 97, green: 31, blue: 83, alpha: 255)),
                MTColorRampStop(value: 25, color: MTRGBAColor(red: 48, green: 23, blue: 58, alpha: 255)),
                MTColorRampStop(value: 30, color: MTRGBAColor(red: 3, green: 5, blue: 26, alpha: 255))
            ]
        }
    }
}
