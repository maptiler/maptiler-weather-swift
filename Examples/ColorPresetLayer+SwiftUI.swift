//
//  ColorPresetLayer+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct ColorPresetLayerView: View {
    @State private var mapView = MTMapView()

    var body: some View {
        MTMapViewContainer(map: mapView) {
            // Map content goes here
        }
        .referenceStyle(.dataviz)
        .styleVariant(.dark) // using dark mode to make colors pop
        .onAppear {
            mapView.registerModule(MapTilerWeatherModule())
        }
        .didTriggerEvent { event, _ in
            if event == .didLoad {
                // Create a layer using a specific color preset
                let colorRamp = MTWeatherColorRamp(preset: .temperatureTurbo)
                let temperatureLayer = MTTemperatureLayer(colorRamp: colorRamp)

                temperatureLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ColorPresetLayerView()
}
