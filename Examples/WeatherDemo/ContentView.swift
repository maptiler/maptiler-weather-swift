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
    case windAndTemp = "Wind & Temp"

    var id: String { self.rawValue }
}

struct ContentView: View {
    @State private var mapView = MTMapView()
    @State private var selectedLayerType: WeatherLayerType = .windAndTemp
    @State private var particleSize: Double = 1.5
    
    // Layers
    @State private var currentLayer: MTWeatherLayer?
    @State private var secondaryLayer: MTWeatherLayer? // Used for the "Wind + Temperature" background
    
    // Animation State
    @State private var isPlaying = false
    @State private var timeSliderValue: Double = 0
    @State private var minTime: Double = 0
    @State private var maxTime: Double = 1
    @State private var currentAnimationDate: Date?
    
    // Layer Settings State
    @State private var repaintOnPaused: Bool = true
    @State private var timeInterpolation: Bool = true
    
    // Picked State
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
                if event == .didLoad {
                    updateWeatherLayer(to: selectedLayerType)
                } else if event == .didTap, let coordinate = data?.coordinate {
                    // For the combined view, we don't show the card popup on tap.
                    if selectedLayerType != .windAndTemp {
                        pickWeather(at: coordinate)
                    }
                }
            }
            .onAppear {
                mapView.registerModule(MapTilerWeatherModule())
            }
            .ignoresSafeArea()

            // Layer Picker & Settings
            HStack(alignment: .top, spacing: 16) {
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

                Menu {
                    Toggle("Repaint While Paused", isOn: $repaintOnPaused)
                    Toggle("Time Interpolation", isOn: $timeInterpolation)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.blue)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.top, 16)
            
            // Pointer Data Card
            if let pickedValue = pickedValue, let pickedLocation = pickedLocation {
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: iconName(for: selectedLayerType))
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedLayerType.rawValue.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Text(pickedValue)
                                .font(.headline)
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
                    .padding(.horizontal)
                    .shadow(radius: 5)
                    Spacer()
                }
                .padding(.top, 80)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: pickedValue)
            }
            
            // Animation Controls (Bottom)
            VStack {
                Spacer()
                
                if selectedLayerType == .wind {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Particle Size")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Slider(value: $particleSize, in: 0.1...5.0)
                                .accentColor(.blue)
                            
                            Text(String(format: "%.1f", particleSize))
                                .font(.system(.body, design: .monospaced))
                                .frame(width: 35)
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }

                VStack(spacing: 12) {
                    if let date = currentAnimationDate {
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                            .font(.headline)
                    } else {
                        Text("Loading data...")
                            .font(.headline)
                    }
                    
                    HStack {
                        Button(action: togglePlayPause) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        
                        Slider(
                            value: Binding(
                                get: { timeSliderValue },
                                set: { newValue in
                                    timeSliderValue = newValue
                                    seekAnimation(to: newValue)
                                }
                            ),
                            in: minTime...maxTime
                        )
                    }
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(16)
                .padding()
                .shadow(radius: 10)
            }
        }
        .onChange(of: selectedLayerType) { newType in
            self.pickedValue = nil
            self.pickedLocation = nil
            self.isPlaying = false
            if let existingMarker = currentMarker {
                mapView.removeMarker(existingMarker)
                currentMarker = nil
            }
            updateWeatherLayer(to: newType)
        }
        .onChange(of: repaintOnPaused) { newValue in
            currentLayer?.setRepaintOnPausedAnimation(newValue)
            secondaryLayer?.setRepaintOnPausedAnimation(newValue)
        }
        .onChange(of: timeInterpolation) { newValue in
            currentLayer?.setTimeInterpolation(newValue)
            secondaryLayer?.setTimeInterpolation(newValue)
        }
        .onChange(of: particleSize) { newValue in
            if let particleLayer = currentLayer as? MTParticleLayer {
                particleLayer.size = newValue
                Task {
                    try? await particleLayer.updateParticleOptions()
                }
            }
        }
    }

    private func updateWeatherLayer(to type: WeatherLayerType) {
        // Stop any running animations
        currentLayer?.animateByFactor(0)
        secondaryLayer?.animateByFactor(0)
        
        // Remove existing layers
        if let existing = currentLayer {
            Task { try? await mapView.style?.removeLayer(existing) }
        }
        if let existingSec = secondaryLayer {
            Task { try? await mapView.style?.removeLayer(existingSec) }
        }
        
        currentLayer = nil
        secondaryLayer = nil

        // Reset water style
        if let style = mapView.style {
            Task {
                await style.setPaintProperty(layerId: "Water", name: "fill-color", value: .string("rgba(0, 0, 0, 0.0)"))
            }
        }

        switch type {
        case .precipitation:
            let newLayer = MTPrecipitationLayer()
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)
            setupEventBindings(for: newLayer)
            newLayer.addTo(mapView)
            currentLayer = newLayer
            
        case .pressure:
            let newLayer = MTPressureLayer()
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)
            setupEventBindings(for: newLayer)
            newLayer.addTo(mapView)
            currentLayer = newLayer
            
        case .radar:
            let newLayer = MTRadarLayer()
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)
            setupEventBindings(for: newLayer)
            newLayer.addTo(mapView)
            currentLayer = newLayer
            
        case .temperature:
            let newLayer = MTTemperatureLayer()
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)
            setupEventBindings(for: newLayer)
            newLayer.addTo(mapView)
            currentLayer = newLayer
            
        case .wind:
            let newLayer = MTWindLayer()
                .size(particleSize)
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)
            setupEventBindings(for: newLayer)
            newLayer.addTo(mapView)
            currentLayer = newLayer
            
        case .windAndTemp:
            if let style = mapView.style {
                Task {
                    await style.setPaintProperty(layerId: "Water", name: "fill-color", value: .string("rgba(0, 0, 0, 0.6)"))
                }
            }

            let tempLayer = MTTemperatureLayer(identifier: "Temperature Background")
            tempLayer.opacity(0.8)
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)
            
            let wind = MTWindLayer(identifier: "Wind Particles")
            wind.colorRamp(MTWeatherColorRamp.none)
                .speed(0.001)
                .fadeFactor(0.03)
                .maxAmount(256)
                .density(200)
                .color(MTRGBAColor(red: 0, green: 0, blue: 0, alpha: 30))
                .fastColor(MTRGBAColor(red: 0, green: 0, blue: 0, alpha: 100))
                .repaintOnPausedAnimation(repaintOnPaused)
                .timeInterpolation(timeInterpolation)

            setupEventBindings(for: wind)

            tempLayer.beforeId("Water")
            tempLayer.addTo(mapView)
            wind.addTo(mapView)

            currentLayer = wind
            secondaryLayer = tempLayer
        }
    }
    
    private func setupEventBindings(for layer: MTWeatherLayer) {
        layer.onSourceReady = {
            Task { @MainActor in
                if let start = try? await layer.getAnimationStart(),
                   let end = try? await layer.getAnimationEnd(),
                   let currentDate = try? await layer.getAnimationTimeDate(),
                   let currentTime = try? await layer.getAnimationTime() {
                    
                    self.minTime = start
                    self.maxTime = end
                    self.timeSliderValue = currentTime
                    self.currentAnimationDate = currentDate
                }
            }
        }
        
        layer.onTick = { time in
            Task { @MainActor in
                self.timeSliderValue = time
                self.currentAnimationDate = Date(timeIntervalSince1970: time)
                
                if let loc = self.pickedLocation, self.isPlaying {
                    self.pickWeather(at: loc)
                }
            }
        }
        
        layer.onAnimationTimeSet = { time in
            Task { @MainActor in
                self.timeSliderValue = time
                self.currentAnimationDate = Date(timeIntervalSince1970: time)
            }
        }
    }
    
    private func togglePlayPause() {
        guard let layer = currentLayer else { return }
        isPlaying.toggle()
        
        let speedMultiplier: Double = 14400 
        if isPlaying {
            layer.animateByFactor(speedMultiplier)
            secondaryLayer?.animateByFactor(speedMultiplier)
        } else {
            layer.animateByFactor(0)
            secondaryLayer?.animateByFactor(0)
        }
    }
    
    private func seekAnimation(to time: Double) {
        currentLayer?.setAnimationTime(time)
        secondaryLayer?.setAnimationTime(time)
    }
    
    private func pickWeather(at coordinate: CLLocationCoordinate2D) {
        guard let layer = currentLayer else { return }
        
        Task {
            do {
                var value: String? = nil
                
                if selectedLayerType == .windAndTemp {
                    let windRes: MTWindValue? = try await (layer as? MTWindLayer)?.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                    let tempRes: MTTemperatureValue? = try await (secondaryLayer as? MTTemperatureLayer)?.pickAt(lng: coordinate.longitude, lat: coordinate.latitude)
                    
                    var valueStr = ""
                    if let t = tempRes {
                        valueStr += String(format: "%.1f °C", t.value)
                    }
                    if let w = windRes {
                        if !valueStr.isEmpty { valueStr += " \n " }
                        valueStr += String(format: "%.1f km/h", w.speedKilometersPerHour)
                    }
                    if !valueStr.isEmpty { value = valueStr }
                } else {
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
                            value = res.map { String(format: "%.1f km/h", $0.speedKilometersPerHour) }
                        }
                    default: break
                    }
                }
                
                let finalValue = value ?? "No data"
                await MainActor.run {
                    self.pickedValue = finalValue
                    self.pickedLocation = coordinate
                    
                    if let existingMarker = currentMarker {
                        mapView.removeMarker(existingMarker)
                    }
                    
                    let newMarker = MTMarker(coordinates: coordinate)
                    newMarker.anchor = .bottom
                    mapView.addMarker(newMarker)
                    currentMarker = newMarker
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
        case .windAndTemp: return "thermometer.and.liquid.waves"
        }
    }
}
