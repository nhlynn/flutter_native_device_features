import 'package:flutter/material.dart';
import 'package:flutter_native_device_features/model/place.dart';
import 'package:flutter_native_device_features/screen/place_detail.dart';
import 'package:flutter_native_device_features/widget/place_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceList extends ConsumerWidget {
  const PlaceList({super.key, required this.places});

  final List<Place> places;

  void _onViewPlace(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceDetail(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No place to show user!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => PlaceItem(
        place: places[index],
        onViewPlace: (place) {
          _onViewPlace(ctx, place);
        },
      ),
    );
  }
}
