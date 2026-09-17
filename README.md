<img src="https://www.maptiler.com/styles/style/logo/maptiler-logo-adaptive.svg?123#maptilerLogo" alt="Company Logo" height="32"/>

# MapTiler Weather SDK for Swift

_Interactive weather layers to customize for MapTiler SDK Swift_

[![](https://img.shields.io/badge/Swift-6.0+-f2f6ff?style=for-the-badge&labelColor=D3DBEC&logo=swift&logoColor=333359)](https://swift.org)
[![](https://img.shields.io/badge/iOS-15.0+-f2f6ff?style=for-the-badge&labelColor=D3DBEC&logo=apple&logoColor=333359)](https://www.apple.com/ios/)
[![](https://img.shields.io/badge/License-BSD--3--Clause-f2f6ff?style=for-the-badge&labelColor=D3DBEC&logo=opensourceinitiative&logoColor=333359)](./LICENSE)

---

📖 [Documentation](https://docs.maptiler.com/mobile-sdk/weather) &nbsp; 📦 [Swift Package](https://github.com/maptiler/maptiler-weather-swift) &nbsp; 🌐 [Website](https://www.maptiler.com/weather/) &nbsp; 🔑 [Get API Key](https://cloud.maptiler.com/account/keys/)

---

<br>

<details> <summary><b>Table of Contents</b></summary>
<ul>
<li><a href="#-installation">Installation</a></li>
<li><a href="#-basic-usage">Basic Usage</a></li>
<li><a href="#-related-examples">Examples</a></li>
<li><a href="#-api-reference">API Reference</a></li>
<li><a href="#-support">Support</a></li>
<li><a href="#-contributing">Contributing</a></li>
<li><a href="#-license">License</a></li>
<li><a href="#-acknowledgements">Acknowledgements</a></li>
</ul>
</details>

## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/maptiler/maptiler-weather-swift.git", from: "1.0.0")
]
```

Or add it via Xcode: `File > Add Packages...` and enter the repository URL.

<br>

## 🚀 Basic Usage

To use weather layers, you first need to register the `MapTilerWeatherModule` with your `MTMapView`.

### 1. Register the Module

```swift
import MapTilerSDK
import MapTilerWeather

// ... in your View or ViewController
mapView.registerModule(MapTilerWeatherModule())
```

### 2. Add a Weather Layer

```swift
// Example: Adding a Wind Layer
let windLayer = MTWindLayer()
windLayer.addTo(mapView)
```

<br>

## 💡 Related Examples

- [Wind Layer](./Examples/WindLayer+SwiftUI.swift)
- [Temperature Layer](./Examples/TemperatureLayer+SwiftUI.swift)
- [Precipitation Layer](./Examples/PrecipitationLayer+SwiftUI.swift)
- [Pressure Layer](./Examples/PressureLayer+SwiftUI.swift)
- [Radar Layer](./Examples/RadarLayer+SwiftUI.swift)

Check out the full list of [MapTiler examples](https://docs.maptiler.com/mobile-sdk/ios/examples/)

<br>

## 📘 API Reference

For detailed guides, API reference, and advanced examples, visit our comprehensive documentation:

[API documentation](https://docs.maptiler.com/mobile-sdk/ios/api/)

<br>

## 💬 Support

- 📚 [Documentation](https://docs.maptiler.com) - Comprehensive guides and API reference
- ✉️ [Contact us](https://maptiler.com/contact) - Get in touch or submit a request
- 🐦 [Twitter/X](https://twitter.com/maptiler) - Follow us for updates

<br>

---

<br>

## 🤝 Contributing

We love contributions from the community! Whether it's bug reports, feature requests, or pull requests, all contributions are welcome:

- Fork the repository and create your branch from `main`
- If you've added code, add tests that cover your changes
- Ensure your code follows our style guidelines
- Open a pull request with a clear summary and comprehensive description

<br>

## 📄 License

This project is licensed under the BSD 3-Clause License – see the [LICENSE](./LICENSE) file for details.

<br>

<p align="center" style="margin-top:20px;margin-bottom:20px;"> <a href="https://cloud.maptiler.com/account/keys/" style="display:inline-block;padding:12px 32px;background:#F2F6FF;color:#000;font-weight:bold;border-radius:6px;text-decoration:none;"> Get Your API Key <sup style="background-color:#0000ff;color:#fff;padding:2px 6px;font-size:12px;border-radius:3px;">FREE</sup><br /> <span style="font-size:90%;font-weight:400;">Start building with 100,000 free map loads per month ・ No credit card required.</span> </a> </p>

<br>

<p align="center"> 💜 Made with love by the <a href="https://www.maptiler.com/">MapTiler</a> team <br />
<p align="center">
  <a href="https://www.maptiler.com/">Website</a> •
</p>

<p align="center">
  <img src="./Examples/maptiler-logo.png" alt="MapTiler Logo" width="200"/>
</p>
