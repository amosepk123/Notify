import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Position? _currentPosition;

  Future<void> _checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Services Disabled'),
        content: Text('Please enable location services.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            child: Text('Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _openInGoogleMaps(double latitude, double longitude) async {
    final googleMapsAppUrl = 'geo:$latitude,$longitude';
    final googleMapsWebUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsAppUrl)) {
      await launch(googleMapsAppUrl);
    } else if (await canLaunch(googleMapsWebUrl)) {
      await launch(googleMapsWebUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark the Location'),
      ),
      body: Center(
        child: _currentPosition == null
            ? Text('Press the button to get your location')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openInGoogleMaps(_currentPosition!.latitude, _currentPosition!.longitude);
              },
              child: Text('Open in Google Maps'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Position position = await _getCurrentPosition();
            setState(() {
              _currentPosition = position;
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        tooltip: 'Get Location',
        child: Icon(Icons.location_on),
      ),
    );
  }
}
