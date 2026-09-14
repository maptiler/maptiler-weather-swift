import Foundation
import os.log

internal enum MTWeatherLogger {
    static let subsystem = "com.maptiler.weather"
    static let poi = OSLog(subsystem: subsystem, category: .pointsOfInterest)
    static let performance = OSLog(subsystem: subsystem, category: "performance")

    static func begin(_ name: StaticString, dso: UnsafeRawPointer = #dsohandle) -> OSSignpostID {
        let id = OSSignpostID(log: poi)
        os_signpost(.begin, log: poi, name: name, signpostID: id)
        return id
    }

    static func end(_ name: StaticString, id: OSSignpostID) {
        os_signpost(.end, log: poi, name: name, signpostID: id)
    }

    static func event(_ name: StaticString, message: String = "") {
        os_signpost(.event, log: poi, name: name, "%{public}s", message)
        // Also log to console for double-verification
        os_log(.default, log: performance, "Weather POI Event: %{public}s - %{public}s", name.description, message)
    }
}
