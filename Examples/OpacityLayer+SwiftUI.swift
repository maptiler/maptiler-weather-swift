//
//  OpacityLayer+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct OpacityLayerView: View {
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
                // Create a temperature layer with 50% opacity
                let temperatureLayer = MTTemperatureLayer().opacity(0.5)

                temperatureLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OpacityLayerView()
}
