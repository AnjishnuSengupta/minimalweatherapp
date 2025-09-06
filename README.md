# 🌤️ Minimal Weather App

A beautiful, modern Flutter weather application that provides real-time weather information with smooth animations and an elegant user interface. The app automatically detects your location and displays current weather conditions with stunning Lottie animations.

<div align="center">

![Flutter CI](https://github.com/AnjishnuSengupta/minimalweatherapp/workflows/Flutter%20CI/badge.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web%20|%20Windows%20|%20macOS%20|%20Linux-lightgrey?style=for-the-badge)

</div>

## ✨ Features

- 🌍 **Automatic Location Detection** - Uses GPS and city name recognition for accurate weather data
- 🎨 **Modern UI Design** - Beautiful gradient backgrounds and smooth animations
- 🌈 **Dynamic Weather Animations** - Lottie animations that match current weather conditions
- 📱 **Cross-Platform** - Runs on Android, iOS, Web, Windows, macOS, and Linux
- 🔄 **Real-time Updates** - Pull-to-refresh functionality for latest weather data
- 🎯 **Accurate Weather Data** - Powered by WeatherAPI for reliable forecasts
- ⚡ **Fast & Lightweight** - Optimized performance with minimal resource usage
- 🎭 **Smooth Animations** - Fade and slide transitions for enhanced user experience

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Minimal-Weather-App.git
   cd Minimal-Weather-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up WeatherAPI**
   - Sign up for a free API key at [WeatherAPI.com](https://www.weatherapi.com/signup.aspx)
   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edit the `.env` file and replace `your_api_key_here` with your actual API key:
     ```
     WEATHER_API_KEY=your_actual_api_key_here
     ```
   - **Important**: Never commit the `.env` file to version control!

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Ensure location permissions are granted
- Minimum SDK version: 21

#### iOS
- Add location permissions to `Info.plist`
- iOS 11.0 or higher required

## 🏗️ Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── weather_model.dart   # Weather data model
├── pages/
│   └── weather_page.dart    # Main weather UI
└── services/
    └── weather_service.dart # API integration & location services
```

### Key Components

- **Weather Model**: Handles weather data structure and JSON parsing
- **Weather Service**: Manages API calls and location detection
- **Weather Page**: Displays UI with animations and user interactions

## 🔧 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Core framework |
| `http` | ^1.5.0 | API requests |
| `geolocator` | ^14.0.2 | Location services |
| `geocoding` | ^4.0.0 | Address to coordinates conversion |
| `lottie` | ^3.3.1 | Weather animations |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `flutter_dotenv` | ^5.1.0 | Environment variables management |

## 🌐 API

This app uses the [WeatherAPI](https://www.weatherapi.com/) for weather data:
- **API Key Required** - Sign up for free at [WeatherAPI.com](https://www.weatherapi.com/signup.aspx)
- **Reliable** - High uptime and accurate data
- **Global coverage** - Weather data worldwide  
- **Real-time** - Current conditions and forecasts
- **Rich Data** - Includes weather icons, UV index, feels-like temperature, and more

## 🎨 Design Philosophy

The Minimal Weather App embraces a clean, modern design approach:

- **Minimalist Interface** - Focus on essential weather information
- **Adaptive Colors** - Gradient backgrounds that reflect weather conditions
- **Smooth Animations** - Enhance user experience without overwhelming
- **Intuitive Navigation** - Simple, gesture-based interactions
- **Responsive Design** - Optimized for all screen sizes

## 📱 Screenshots

*Screenshots coming soon - the app features beautiful weather animations and modern UI design*

## 🛠️ Development

### Running in Development Mode

```bash
flutter run --debug
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop (Windows)
flutter build windows --release

# Desktop (macOS)
flutter build macos --release

# Desktop (Linux)
flutter build linux --release
```

### Testing

```bash
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [WeatherAPI](https://www.weatherapi.com/) for providing accurate weather data
- [LottieFiles](https://lottiefiles.com/) for beautiful weather animations
- Flutter team for the amazing framework
- All contributors and users of this app

---

<div align="center">

**Made with ❤️ and Flutter**

⭐ Star this repo if you found it helpful!

</div>
