//
//  WindLayer+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct WindLayerView: View {
    @State private var mapView = MTMapView()

    var body: some View {
        MTMapViewContainer(map: mapView) {
            // Map content goes here
        }
        .referenceStyle(.dataviz)
        .styleVariant(.dark)
        .onAppear {
            // Register the weather module to enable weather layers
            mapView.registerModule(MapTilerWeatherModule())
        }
        .didTriggerEvent { event, _ in
            // Wait for the style to be loaded before adding weather layers
            if event == .didLoad {
                // Create a new wind layer with default settings
                let windLayer = MTWindLayer()

                // Add the layer to the map
                windLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WindLayerView()
}
