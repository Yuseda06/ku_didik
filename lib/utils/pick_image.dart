import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ku_didik/utils/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  Uint8List? _image;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Image"),
      ),
      backgroundColor: Color.fromARGB(255, 252, 247, 231),
      body: Center(
        child: Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 100, backgroundImage: MemoryImage(_image!))
                : const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                  ),
            Positioned(
              bottom: -0,
              left: 140,
              child: IconButton(
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.teal,
                  size: 50,
                ),
                onPressed: () {
                  showImagePickerOption(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 218, 250, 246),
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                            color: Colors.teal,
                          ),
                          Text("Gallery",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            color: Colors.teal,
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Provider.of<ProfileProvider>(context, listen: false)
        .setImage(selectedImage);
    Navigator.of(context).pop();
  }

  // Camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;

    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });

    // Convert the image to base64 and store in the provider
    Provider.of<ProfileProvider>(context, listen: false)
        .setImage(selectedImage);
    Navigator.of(context).pop();
  }
}
