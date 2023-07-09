import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_device_features/model/place.dart';
import 'package:flutter_native_device_features/screen/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickLocation == null) {
      return '';
    }
    final lat = _pickLocation?.latitude;
    final lng = _pickLocation?.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap &markers=color:red %7Clabel:A%7C$lat,$lng &key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag";
  }

  Future<void> _savePlace(double latitude, double longitude) async{
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag');
    final httpResponse = await http.get(url);
    final response = jsonDecode(httpResponse.body);
    final address = response['results'][0]['formatted_address'];

    setState(() {
      _pickLocation =
          PlaceLocation(latitude: latitude, longitude: longitude, address: address);
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude!;
    final lng = locationData.longitude!;

   _savePlace(lat, lng);
  }

  void _selectOnMap() async{
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if(pickedLocation == null){
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text(
        'No location chosen!',
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );

    if (_pickLocation != null) {
      mainContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      mainContent = const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          alignment: Alignment.center,
          child: mainContent,
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () async {
                _getCurrentLocation();
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}
