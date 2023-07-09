import 'package:flutter/material.dart';
import 'package:flutter_native_device_features/model/place.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    super.key,
    required this.place,
    required this.onViewPlace,
  });

  final Place place;
  final void Function(Place place) onViewPlace;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        return onViewPlace(place);
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: FileImage(place.selectImage),
      ),
      title: Text(
        place.title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        place.placeLocation.address,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
