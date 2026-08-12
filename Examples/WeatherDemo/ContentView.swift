//
//  ContentView.swift
//  WeatherDemo
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct ContentView: View {
    @State private var mapView = MTMapView()

    var body: some View {
        ZStack {
            MTMapViewContainer(map: mapView) {
                // Map content goes here
            }
            .referenceStyle(.dataviz)
            .styleVariant(.light)
            .didTriggerEvent { event, _ in
                // Wait for the style to be loaded before adding weather layers
                if event == .didLoad {
                    // Create a new precipitation layer with default settings
                    let precipitationLayer = MTPrecipitationLayer()

                    // Add the layer to the map
                    precipitationLayer.addTo(mapView)
                }
            }
            .onAppear {
                // Register the weather module to enable weather layers
                mapView.registerModule(MapTilerWeatherModule())
            }
            .ignoresSafeArea()
        }
    }
}
