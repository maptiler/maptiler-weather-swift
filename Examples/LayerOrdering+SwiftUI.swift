//
//  LayerOrdering+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct LayerOrderingView: View {
    @State private var mapView = MTMapView()

    var body: some View {
        MTMapViewContainer(map: mapView) {
            // Map content goes here
        }
        .referenceStyle(.dataviz)
        .styleVariant(.light)
        .onAppear {
            mapView.registerModule(MapTilerWeatherModule())
        }
        .didTriggerEvent { event, _ in
            if event == .didLoad {
                // Place the weather layer beneath map labels or specific layers (e.g., 'water')
                // so that text or other important map features remain readable on top of the weather
                let temperatureLayer = MTTemperatureLayer().beforeId("water")

                temperatureLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LayerOrderingView()
}
