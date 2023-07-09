import 'package:flutter/material.dart';
import 'package:flutter_native_device_features/model/place.dart';
import 'package:flutter_native_device_features/provider/place_provider.dart';
import 'package:flutter_native_device_features/widget/image_input.dart';
import 'package:flutter_native_device_features/widget/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final titleController = TextEditingController();
  File? _selectImage;
  PlaceLocation? _placeLocation;

  void _savePlace() {
    if (titleController.text.isEmpty ||
        _selectImage == null ||
        _placeLocation == null) {
      return;
    }

    var place = Place(
      title: titleController.text.trim().toString(),
      selectImage: _selectImage!,
      placeLocation: _placeLocation!,
    );
    ref.read(placeProvider.notifier).addPlace(place);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 8,
              ),
              ImageInput(onSelectImage: (image) {
                setState(() {
                  _selectImage = image;
                });
              }),
              const SizedBox(
                height: 8,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  setState(() {
                    _placeLocation = location;
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
