import 'package:flutter/material.dart';
import 'dart:io';
import 'noise_removal_dialog.dart';
import 'brightness_dialog.dart';
import 'perspective_dialog.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../services/image_processor.dart';


class ImageProcessingPage extends StatefulWidget {
  final File imageFile;

  const ImageProcessingPage({super.key, required this.imageFile});

  @override
  ImageProcessingPageState createState() => ImageProcessingPageState();
}

class ImageProcessingPageState extends State<ImageProcessingPage> {
  int kernelSize = 5;
  double sigmaX = 1.0;
  bool useMedianBlur = false;
  double noiseRemovalStrength = 0.5;
  double brightness = 0.5;
  double perspective = 0.5;

  String? processedImageBase64;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preprocessing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            Image.file(widget.imageFile, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),


            if (processedImageBase64 != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text("Processed Image", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Image.memory(
                    base64Decode(processedImageBase64!),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ],
              ),


            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 30),
                  ),
                  onPressed: () {
                    //
                    removeNoise();
                  },
                  child: Text("Remove Noise"),
                ),
                IconButton(
                  onPressed: () async {

                    double? newStrength = await showDialog(
                      context: context,
                      builder: (context) {
                        return NoiseRemovalDialog(initialStrength: noiseRemovalStrength);
                      },
                    );

                    if (newStrength != null) {
                      setState(() {
                        noiseRemovalStrength = newStrength;
                      });
                    }
                  },
                  icon: Icon(Icons.settings),
                  color: Colors.blue,
                ),
              ],
            ),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 30),
                  ),

                  onPressed: () {
                    //

                  },
                  child: Text("contrast/brightness"),
                ),
                IconButton(
                  onPressed: () async {
                    //
                    double? newBrightness = await showDialog(
                      context: context,
                      builder: (context) {
                        return BrightnessDialog(initialBrightness: brightness);
                      },
                    );

                    if (newBrightness != null) {
                      setState(() {
                        brightness = newBrightness;
                      });
                    }
                  },
                  icon: Icon(Icons.settings),
                  color: Colors.blue,
                ),
              ],
            ),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 30),
                  ),

                  onPressed: () {
                    //

                  },
                  child: Text("Align Perspective"),
                ),
                IconButton(
                  onPressed: () async {
                    //
                    double? newPerspective = await showDialog(
                      context: context,
                      builder: (context) {
                        return PerspectiveDialog(initialPerspective: perspective);
                      },
                    );

                    if (newPerspective != null) {
                      setState(() {
                        perspective = newPerspective;
                      });
                    }
                  },
                  icon: Icon(Icons.settings),
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 20),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //

                  },
                  child: const Text("Confirm"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    //
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //
  Future<void> removeNoise() async {
    //
    String? base64Image = await ImageProcessor.removeNoise(widget.imageFile as String,kernelSize,sigmaX,useMedianBlur);

    if (base64Image != null) {
      setState(() {
        processedImageBase64 = base64Image;
      });
    }
  }

}