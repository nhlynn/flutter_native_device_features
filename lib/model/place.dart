import 'package:uuid/uuid.dart';
import 'dart:io';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.selectImage,
    required this.placeLocation,
    id
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File selectImage;
  final PlaceLocation placeLocation;
}
