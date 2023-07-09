import 'dart:io';

import 'package:flutter_native_device_features/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Future<Database> _getDatabase() async {
  final dbPath = await getDatabasesPath();
  final database = await openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) async {
      return await db.execute(
        'CREATE TABLE your_place (id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)',
      );
    },
    version: 2,
  );

  return database;
}

class PlaceNotifier extends StateNotifier<List<Place>> {
  PlaceNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('your_place');
    final places = data
        .map(
          (row) => Place(
            id: row['id'],
            title: row['title'] as String,
            selectImage: File(row['image'] as String),
            placeLocation: PlaceLocation(
              latitude: row['latitude'] as double,
              longitude: row['longitude'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.selectImage.path);

    final copyImage = await place.selectImage.copy('${appDir.path}/$fileName');

    final newPlace = Place(
        title: place.title,
        selectImage: copyImage,
        placeLocation: place.placeLocation);

    final db = await _getDatabase();
    db.insert(
      'your_place',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.selectImage.path,
        'latitude': newPlace.placeLocation.latitude,
        'longitude': newPlace.placeLocation.longitude,
        'address': newPlace.placeLocation.address,
      },
    );

    state = [newPlace, ...state];
  }
}

var placeProvider =
    StateNotifierProvider<PlaceNotifier, List<Place>>((ref) => PlaceNotifier());
