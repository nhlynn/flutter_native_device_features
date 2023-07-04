import 'package:flutter_native_device_features/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceNotifier extends StateNotifier<List<Place>> {
  PlaceNotifier() : super([]);

  void addPlace(Place place) {
    state = [place,...state];
  }
}

var placeProvider = StateNotifierProvider<PlaceNotifier,List<Place>>((ref) => PlaceNotifier());
