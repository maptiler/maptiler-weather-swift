//
//  StaticTimeLayer+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct StaticTimeLayerView: View {
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
                // Create a layer fixed to a specific time (e.g. now) instead of an animation loop
                let temperatureLayer = MTTemperatureLayer().time(Date())

                temperatureLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StaticTimeLayerView()
}
