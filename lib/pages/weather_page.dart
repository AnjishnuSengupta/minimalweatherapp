import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimalweatherapp/models/weather_model.dart';
import 'package:minimalweatherapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  final _weatherService = WeatherService(); // No API key needed for Open-Meteo
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getCurrentWeather();
      setState(() {
        _weather = weather;
        _isLoading = false;
      });

      // Start animations when weather is loaded
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data: $e';
        _isLoading = false;
      });
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/Weather-sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return 'assets/Weather-sunny.json';
      case 'partly cloudy':
        return 'assets/Weather-partly cloudy.json';
      case 'foggy':
        return 'assets/Weather-mist.json';
      case 'drizzle':
        return 'assets/Weather-partly shower.json';
      case 'freezing drizzle':
        return 'assets/Weather-partly shower.json';
      case 'rainy':
        return 'assets/Weather-storm.json';
      case 'freezing rain':
        return 'assets/Weather-storm.json';
      case 'snowy':
        return 'assets/Weather-snow.json';
      case 'snow grains':
        return 'assets/Weather-snow.json';
      case 'rain showers':
        return 'assets/Weather-storm&showers(day).json';
      case 'snow showers':
        return 'assets/Weather-snow.json';
      case 'thunderstorm':
        return 'assets/Weather-storm.json';
      case 'thunderstorm with hail':
        return 'assets/Weather-storm.json';
      default:
        return 'assets/Weather-sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fetchWeather();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getGradientColors(),
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? _buildLoadingState()
              : _errorMessage != null
              ? _buildErrorState()
              : _buildWeatherContent(),
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    if (_weather == null) {
      return [Color(0xFF74b9ff), Color(0xFF0984e3)];
    }

    // Dynamic gradient based on weather condition
    switch (_weather!.mainCondition.toLowerCase()) {
      case 'clear':
        return [Color(0xFFFFD700), Color(0xFFFF6347)]; // Sunny
      case 'partly cloudy':
        return [Color(0xFF74b9ff), Color(0xFF0984e3)]; // Partly cloudy
      case 'rainy':
      case 'rain showers':
        return [Color(0xFF636e72), Color(0xFF2d3436)]; // Rainy
      case 'thunderstorm':
        return [Color(0xFF2d3436), Color(0xFF000000)]; // Storm
      case 'snowy':
      case 'snow showers':
        return [Color(0xFFddd6fe), Color(0xFF8b5cf6)]; // Snowy
      case 'foggy':
        return [Color(0xFFb2bec3), Color(0xFF636e72)]; // Foggy
      default:
        return [Color(0xFF74b9ff), Color(0xFF0984e3)]; // Default
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Getting your location...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait while we fetch your weather',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchWeather,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF0984e3),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    _buildLocationHeader(),
                    SizedBox(height: 24),
                    _buildMainWeatherCard(),
                    SizedBox(height: 20),
                    _buildDetailsCards(),
                    SizedBox(height: 20),
                    _buildRefreshButton(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              _weather?.cityName ?? 'Unknown Location',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          _getCurrentTime(),
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMainWeatherCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weather animation
          SizedBox(
            height: 160,
            width: 160,
            child: Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20),
          // Temperature
          Text(
            '${_weather?.temperature.round() ?? '--'}°',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              height: 1,
            ),
          ),
          SizedBox(height: 12),
          // Weather condition
          Text(
            _weather?.mainCondition ?? "Loading...",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          // Weather description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _getWeatherDescription(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailCard(
            icon: Icons.water_drop_rounded,
            title: 'Humidity',
            value: '${_weather?.humidity.round() ?? '--'}%',
            color: Colors.blue,
            delay: 0,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildDetailCard(
            icon: Icons.air_rounded,
            title: 'Wind Speed',
            value: '${_weather?.windSpeed.round() ?? '--'} km/h',
            color: Colors.teal,
            delay: 200,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    int delay = 0,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildRefreshButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _animationController.reset();
          _fetchWeather();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.15),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              'Refresh Weather',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return 'Updated at $hour:$minute';
  }

  String _getWeatherDescription() {
    if (_weather == null) return '';

    switch (_weather!.mainCondition.toLowerCase()) {
      case 'clear':
        return 'Perfect day to go outside and enjoy the sunshine!';
      case 'partly cloudy':
        return 'A beautiful day with some clouds in the sky.';
      case 'rainy':
        return 'Don\'t forget your umbrella when going out.';
      case 'thunderstorm':
        return 'Stay indoors and stay safe during the storm.';
      case 'snowy':
        return 'Bundle up warm, it\'s snowing outside!';
      case 'foggy':
        return 'Visibility might be low, drive carefully.';
      default:
        return 'Have a great day!';
    }
  }
}
