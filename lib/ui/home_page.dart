import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  //
  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    setState(() {
      if (image != null ) {
        _image = File(image.path);
      }
    });

    if (_image != null  && mounted) {
      // ResultPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(imageFile: _image!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TreadScan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 30),
              ),
              icon: const Icon(Icons.camera),
              label: const Text("Taken with a camera"),
              onPressed: () => _getImage(ImageSource.camera),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 30),
              ),

              icon: const Icon(Icons.photo),
              label: const Text("Select from gallery"),
              onPressed: () => _getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}