//
//  WeatherDemoApp.swift
//  WeatherDemo
//

import SwiftUI
import MapTilerSDK

@main
struct WeatherDemoApp: App {
    init() {
        // Set your MapTiler API Key here
        // Get your free API key at https://maptiler.com/cloud/
        Task {
            await MTConfig.shared.setAPIKey("YOUR_API_KEY")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
