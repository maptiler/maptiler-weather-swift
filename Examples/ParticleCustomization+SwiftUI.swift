//
//  ParticleCustomization+SwiftUI.swift
//  MapTilerWeather
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

struct ParticleCustomizationView: View {
    @State private var mapView = MTMapView()

    var body: some View {
        MTMapViewContainer(map: mapView) {
            // Map content goes here
        }
        .referenceStyle(.dataviz)
        .styleVariant(.dark)
        .onAppear {
            mapView.registerModule(MapTilerWeatherModule())
        }
        .didTriggerEvent { event, _ in
            if event == .didLoad {
                // Create a wind layer and customize its particle properties
                let windLayer = MTWindLayer()
                    .size(2.5)       // Make particles larger
                    .density(3.0)    // Increase number of particles
                    .speed(0.005)    // Adjust the speed factor
                
                windLayer.addTo(mapView)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ParticleCustomizationView()
}
