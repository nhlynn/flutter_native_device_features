import 'package:flutter/material.dart';
import 'package:flutter_native_device_features/provider/place_provider.dart';
import 'package:flutter_native_device_features/screen/add_place.dart';
import 'package:flutter_native_device_features/screen/place_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var places = ref.watch(placeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PlaceList(places: places),
    );
  }
}
