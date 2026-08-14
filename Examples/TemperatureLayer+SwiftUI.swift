//
//  TemperatureLayer+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct TemperatureLayerView: View {
    @State private var mapView = MTMapView()

    var body: some View {
        MTMapViewContainer(map: mapView) {
            // Map content goes here
        }
        .referenceStyle(.dataviz)
        .styleVariant(.light)
        .onAppear {
            // Register the weather module to enable weather layers
            mapView.registerModule(MapTilerWeatherModule())
        }
        .didTriggerEvent { event, _ in
            // Wait for the style to be loaded before adding weather layers
            if event == .didLoad {
                // Create a new temperature layer with default settings
                let temperatureLayer = MTTemperatureLayer()

                // Add the layer to the map
                temperatureLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    TemperatureLayerView()
}
