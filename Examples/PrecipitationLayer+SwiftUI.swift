//
//  PrecipitationLayer+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct PrecipitationLayerView: View {
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
                // Create a new precipitation layer with default settings
                let precipitationLayer = MTPrecipitationLayer()

                // Add the layer to the map
                precipitationLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PrecipitationLayerView()
}
