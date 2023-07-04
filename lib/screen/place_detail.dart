import 'package:flutter/material.dart';
import 'package:flutter_native_device_features/model/place.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({
    super.key,
    required this.place,
  });

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.selectImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }
}
