import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/client/BioskopClient.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _currentLocation = "---";
  final BioskopClient client = BioskopClient();
  bool _showPermissionPrompt = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
    _getCurrentLocation(); // Memperbarui lokasi saat halaman dibuka
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('currentLocation');
    bool permissionRequested = prefs.getBool('permissionRequested') ?? false;

    if (savedLocation != null) {
      setState(() {
        _currentLocation = savedLocation;
      });
    } else if (!permissionRequested) {
      // If location hasn't been requested yet, ask for permission
      await _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await _getCurrentLocation();
    } else {
      setState(() {
        _currentLocation = "Location permission denied.";
        _showPermissionPrompt = true;
      });
    }

    await prefs.setBool('permissionRequested', true);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _getCityFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _currentLocation = "Failed to get location: $e";
      });
    }
  }

  // Mengambil nama kota dari koordinat
  Future<void> _getCityFromCoordinates(
      double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': 'YourAppName/1.0 (your-email@example.com)',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Menampilkan hanya nama kota
        final city = _extractCityName(data['address']);
        setState(() {
          _currentLocation = city ?? 'City not found';
        });
        await _saveLocation(_currentLocation);
      } else {
        setState(() {
          _currentLocation = 'Failed to get address';
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = 'Error: $e';
      });
    }
  }

  String? _extractCityName(Map<String, dynamic> addressData) {
    // Mencari nama kota dari addressData
    if (addressData.containsKey('city')) {
      return addressData['city'];
    } else if (addressData.containsKey('town')) {
      return addressData['town'];
    } else if (addressData.containsKey('village')) {
      return addressData['village'];
    }
    return null;
  }

  Future<void> _saveLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLocation', location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Location',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Icon(Icons.arrow_back_ios, color: lightColor),
              ),
              Text(
                'Back',
                style: TextStyle(color: lightColor),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (_showPermissionPrompt)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blueAccent, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Location Is Not Detected\nTurn on your location access to get your current location',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Your Current Location:',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              _currentLocation,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Divider(color: Colors.grey),
            Expanded(
              child: ListView(
                children: [
                  _buildCityTile('Jakarta'),
                  _buildCityTile('Bandung'),
                  _buildCityTile('Surabaya'),
                  _buildCityTile('Yogyakarta'),
                  _buildCityTile('Bali'),
                  _buildCityTile('Medan'),
                  _buildCityTile('Makassar'),
                  _buildCityTile('Semarang'),
                  _buildCityTile('Palembang'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('currentLocation', _currentLocation);

                  Navigator.of(context).pop(_currentLocation);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCC434),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(84),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityTile(String cityName) {
    return ListTile(
      title: Text(
        cityName,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: () {
        setState(() {
          _currentLocation = cityName;
        });
        _saveLocation(_currentLocation);  // Menyimpan lokasi baru
      }
    );
  }
}