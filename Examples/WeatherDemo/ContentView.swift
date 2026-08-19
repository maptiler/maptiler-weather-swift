//
//  ContentView.swift
//  WeatherDemo
//

import SwiftUI
import MapTilerSDK
import MapTilerWeather
import CoreLocation

enum WeatherLayerType: String, CaseIterable, Identifiable {
    case precipitation = "Precipitation"
    case pressure = "Pressure"
    case radar = "Radar"
    case temperature = "Temperature"
    case wind = "Wind"

    var id: String { self.rawValue }
}

struct ContentView: View {
    @State private var mapView = MTMapView()
    @State private var selectedLayerType: WeatherLayerType = .precipitation
    @State private var currentLayer: MTWeatherLayer?
    
    // State for picked weather data
    @State private var pickedValue: String?
    @State private var pickedLocation: CLLocationCoordinate2D?
    @State private var currentMarker: MTMarker?

    var body: some View {
        ZStack(alignment: .top) {
            MTMapViewContainer(map: mapView) {
                // Map content goes here
            }
            .referenceStyle(.backdrop)
            .styleVariant(.light)
            .didTriggerEvent { event, data in
                // Wait for the style to be loaded before adding weather layers
                if event == .didLoad {
                    updateWeatherLayer(to: selectedLayerType)
                } else if event == .didTap, let coordinate = data?.coordinate {
                    pickWeather(at: coordinate)
                }
            }
            .onAppear {
                // Register the weather module to enable weather layers
                mapView.registerModule(MapTilerWeatherModule())
            }
            .ignoresSafeArea()

            // Layer Picker
            VStack {
                Menu {
                    Picker("Weather Layer", selection: $selectedLayerType) {
                        ForEach(WeatherLayerType.allCases) { layerType in
                            Label(layerType.rawValue, systemImage: iconName(for: layerType))
                                .tag(layerType)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: iconName(for: selectedLayerType))
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Text(selectedLayerType.rawValue)
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(.secondary)
                            .imageScale(.small)
                    }
                    .padding()
                    .frame(width: 240)
                    .background(.regularMaterial)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.top, 16)
            
            // Weather Data Card
            if let pickedValue = pickedValue, let pickedLocation = pickedLocation {
                VStack {
                    Spacer()
                    HStack(spacing: 15) {
                        Image(systemName: iconName(for: selectedLayerType))
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedLayerType.rawValue)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            Text(pickedValue)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(String(format: "%.4f, %.4f", pickedLocation.latitude, pickedLocation.longitude))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.pickedValue = nil
                            self.pickedLocation = nil
                            if let existingMarker = currentMarker {
                                mapView.removeMarker(existingMarker)
                                currentMarker = nil
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .animation(.spring(), value: pickedValue)
            }
        }
        .onChange(of: selectedLayerType) { newType in
            // Clear picked data when layer changes
            self.pickedValue = nil
            self.pickedLocation = nil
            if let existingMarker = currentMarker {
                mapView.removeMarker(existingMarker)
                currentMarker = nil
            }
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
        case .temperature:
            newLayer = MTTemperatureLayer()
        case .wind:
            newLayer = MTWindLayer()
        }

        newLayer.addTo(mapView)
        currentLayer = newLayer
    }
    
    private func pickWeather(at coordinate: CLLocationCoordinate2D) {
        guard let layer = currentLayer else { return }
        
        Task {
            do {
                var value: String? = nil
                switch selectedLayerType {
                case .precipitation:
                    if let precipLayer = layer as? MTPrecipitationLayer {
                        let res: MTPrecipitationValue? = try await precipLayer.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                        value = res.map { String(format: "%.1f mm/h", $0.value) }
                    }
                case .pressure:
                    if let pressureLayer = layer as? MTPressureLayer {
                        let res: MTPressureValue? = try await pressureLayer.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                        value = res.map { String(format: "%.0f hPa", $0.value) }
                    }
                case .radar:
                    if let radarLayer = layer as? MTRadarLayer {
                        let res: MTRadarValue? = try await radarLayer.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                        value = res.map { String(format: "%.1f dBZ", $0.value) }
                    }
                case .temperature:
                    if let temperatureLayer = layer as? MTTemperatureLayer {
                        let res: MTTemperatureValue? = try await temperatureLayer.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                        value = res.map { String(format: "%.1f °C", $0.value) }
                    }
                case .wind:
                    if let windLayer = layer as? MTWindLayer {
                        let res: MTWindValue? = try await windLayer.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                        value = res.map { String(format: "%.1f m/s %@", $0.speedMetersPerSecond, $0.compassDirection) }
                    }
                }
                
                let finalValue = value
                await MainActor.run {
                    self.pickedValue = finalValue
                    self.pickedLocation = coordinate
                    
                    // Update marker
                    if let existingMarker = currentMarker {
                        mapView.removeMarker(existingMarker)
                    }
                    if finalValue != nil {
                        let newMarker = MTMarker(coordinates: coordinate)
                        newMarker.anchor = .bottom
                        mapView.addMarker(newMarker)
                        currentMarker = newMarker
                    }
                }
            } catch {
                print("Failed to pick weather: \(error)")
            }
        }
    }
    
    private func iconName(for type: WeatherLayerType) -> String {
        switch type {
        case .precipitation: return "cloud.rain.fill"
        case .pressure: return "gauge.medium"
        case .radar: return "antenna.radiowaves.left.and.right"
        case .temperature: return "thermometer"
        case .wind: return "wind"
        }
    }
}
