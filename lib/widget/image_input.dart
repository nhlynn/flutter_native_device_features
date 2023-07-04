import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});

  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectImage;

  void _pickPicture() async {
    final picker = ImagePicker();
    final photo =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (photo == null) {
      return;
    }

    setState(() {
      _selectImage = File(photo.path);
    });

    widget.onSelectImage(_selectImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = TextButton.icon(
      onPressed: () async {
        _pickPicture();
      },
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    if (_selectImage != null) {
      mainContent = Image.file(
        _selectImage!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      )),
      alignment: Alignment.center,
      child: mainContent,
    );
  }
}
