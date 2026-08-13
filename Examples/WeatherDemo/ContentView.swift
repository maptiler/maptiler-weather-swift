//
//  ContentView.swift
//  WeatherDemo
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather

enum WeatherLayerType: String, CaseIterable, Identifiable {
    case precipitation = "Precipitation"
    case pressure = "Pressure"
    case radar = "Radar"

    var id: String { self.rawValue }
}

struct ContentView: View {
    @State private var mapView = MTMapView()
    @State private var selectedLayerType: WeatherLayerType = .precipitation
    @State private var currentLayer: MTWeatherLayer?

    var body: some View {
        ZStack(alignment: .top) {
            MTMapViewContainer(map: mapView) {
                // Map content goes here
            }
            .referenceStyle(.dataviz)
            .styleVariant(.light)
            .didTriggerEvent { event, _ in
                // Wait for the style to be loaded before adding weather layers
                if event == .didLoad {
                    updateWeatherLayer(to: selectedLayerType)
                }
            }
            .onAppear {
                // Register the weather module to enable weather layers
                mapView.registerModule(MapTilerWeatherModule())
            }
            .ignoresSafeArea()

            // Layer Picker
            VStack {
                Picker("Weather Layer", selection: $selectedLayerType) {
                    ForEach(WeatherLayerType.allCases) { layerType in
                        Text(layerType.rawValue).tag(layerType)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(radius: 5)
            }
            .padding(.top, 16)
        }
        .onChange(of: selectedLayerType) { newType in
            updateWeatherLayer(to: newType)
        }
    }

    private func updateWeatherLayer(to type: WeatherLayerType) {
        // Remove existing layer if any
        if let existingLayer = currentLayer {
            Task {
                try? await mapView.style?.removeLayer(existingLayer)
            }
        }

        // Create and add new layer
        let newLayer: MTWeatherLayer
        switch type {
        case .precipitation:
            newLayer = MTPrecipitationLayer()
        case .pressure:
            newLayer = MTPressureLayer()
        case .radar:
            newLayer = MTRadarLayer()
        }

        newLayer.addTo(mapView)
        currentLayer = newLayer
    }
}
